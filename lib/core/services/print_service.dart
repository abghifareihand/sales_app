import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothPrinter {
  const BluetoothPrinter({required this.name, required this.address});

  final String name;
  final String address;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BluetoothPrinter && other.name == name && other.address == address;
  }

  @override
  int get hashCode => Object.hash(name, address);
}

class PrintServiceException implements Exception {
  PrintServiceException(this.message);
  final String message;

  @override
  String toString() => 'PrintServiceException: $message';
}

class PrintService {
  PrintService._();

  static final PrintService instance = PrintService._();

  static const _printerNameKey = 'selected_printer_name';
  static const _printerAddressKey = 'selected_printer_address';

  SharedPreferences? _prefs;
  BluetoothPrinter? _selectedPrinter;

  Future<void> init() async {
    await _ensurePrefs();
    final savedPrinter = await _loadSavedPrinter();
    if (savedPrinter != null) {
      await _autoReconnect(savedPrinter);
    }
  }

  Future<bool> get connectionStatus async {
    return PrintBluetoothThermal.connectionStatus;
  }

  Future<bool> get isBluetoothEnabled async {
    return PrintBluetoothThermal.bluetoothEnabled;
  }

  Future<bool> get hasBluetoothPermission async {
    return PrintBluetoothThermal.isPermissionBluetoothGranted;
  }

  /// Request bluetooth permission from user
  Future<bool> requestBluetoothPermission() async {
    try {
      // For Android API 31+ (Android 12+), need BLUETOOTH_SCAN and BLUETOOTH_CONNECT
      if (await Permission.bluetoothScan.isDenied) {
        final scanStatus = await Permission.bluetoothScan.request();
        if (!scanStatus.isGranted) return false;
      }

      if (await Permission.bluetoothConnect.isDenied) {
        final connectStatus = await Permission.bluetoothConnect.request();
        if (!connectStatus.isGranted) return false;
      }

      // For older Android versions, need BLUETOOTH and BLUETOOTH_ADMIN
      if (await Permission.bluetooth.isDenied) {
        final bluetoothStatus = await Permission.bluetooth.request();
        if (!bluetoothStatus.isGranted) return false;
      }

      // Also need location permission for Bluetooth scanning on some devices
      if (await Permission.location.isDenied) {
        final locationStatus = await Permission.location.request();
        if (!locationStatus.isGranted) return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting Bluetooth permission: $e');
      }
      return false;
    }
  }

  Future<List<BluetoothPrinter>> scanPrinters() async {
    final printers = await PrintBluetoothThermal.pairedBluetooths;
    return printers
        .map((printer) => BluetoothPrinter(name: printer.name, address: printer.macAdress))
        .toList();
  }

  Future<BluetoothPrinter?> getSavedPrinter() async {
    if (_selectedPrinter != null) {
      return _selectedPrinter;
    }
    return _loadSavedPrinter();
  }

  Future<bool> connectToPrinter(BluetoothPrinter printer, {bool persistSelection = true}) async {
    try {
      final result = await PrintBluetoothThermal.connect(macPrinterAddress: printer.address);
      if (result) {
        _selectedPrinter = printer;
        if (persistSelection) {
          final prefs = await _ensurePrefs();
          await prefs.setString(_printerNameKey, printer.name);
          await prefs.setString(_printerAddressKey, printer.address);
        }
      }
      return result;
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print('Failed to connect printer: $error');
      }
      return false;
    }
  }

  Future<void> forgetPrinter() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_printerNameKey);
    await prefs.remove(_printerAddressKey);
    _selectedPrinter = null;
  }

  Future<bool> ensureConnected() async {
    if (await PrintBluetoothThermal.connectionStatus) {
      return true;
    }
    final printer = await getSavedPrinter();
    if (printer == null) {
      return false;
    }
    return connectToPrinter(printer, persistSelection: false);
  }

  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to disconnect printer: $error');
      }
    }
  }

  Future<void> printReceiptTest() async {
    final connected = await ensureConnected();
    if (!connected) {
      throw PrintServiceException('Printer belum terhubung.');
    }

    final bytes = await buildReceiptBytesTest();
    final success = await _write(bytes);
    if (!success) {
      throw PrintServiceException('Gagal mengirim data ke printer.');
    }
  }

  Future<List<int>> buildReceiptBytesTest() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

    bytes += generator.reset();

    // Test print sederhana
    bytes += generator.text(
      'Test Printer',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.feed(1); // spasi agar printer potong kertas
    bytes += generator.cut(); // optional, kalau printer support cut

    return bytes;
  }

  Future<void> printReceipt(Transaction data) async {
    final connected = await ensureConnected();
    if (!connected) {
      throw PrintServiceException('Printer belum terhubung.');
    }

    final bytes = await buildReceiptBytes(data);
    final success = await _write(bytes);
    if (!success) {
      throw PrintServiceException('Gagal mengirim data ke printer.');
    }
  }

  Future<List<int>> buildReceiptBytes(Transaction data) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.text(
      data.sales.toUpperCase(),
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(1); // spasi 1 baris

    // kiri
    // bytes += generator.text('Toko    : ${data.outlet.nameOutlet}');
    // bytes += generator.text('Alamat  : ${data.outlet.addressOutlet}');
    // bytes += generator.text('Tanggal : ${Formatter.toDateTimeFull(data.createdAt)}');

    // tengah
    bytes += generator.text(
      data.outlet.nameOutlet,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      data.outlet.addressOutlet,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      Formatter.toDateTimeFull(data.createdAt),
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr();

    // Detail item
    if (data.items.isEmpty) {
      bytes += generator.text('Tidak ada detail layanan');
    } else {
      for (final item in data.items) {
        // Nama produk di baris pertama
        bytes += generator.text('${item.name}|${item.provider}');
        bytes += generator.text('${item.category}|${item.kuota}');

        // Hitung total per item
        final totalItem = item.quantity * item.price;

        // Harga x qty kiri, total kanan di baris kedua
        final qtyLine = '${Formatter.toNoRupiahDouble(item.price)} x ${item.quantity}';
        bytes += generator.row([
          PosColumn(text: qtyLine, width: 6),
          PosColumn(
            text: Formatter.toNoRupiahDouble(totalItem),
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        // Feed 4 dot ≈ 0.5 mm
        bytes += generator.rawBytes([0x1B, 0x4A, 4]);
      }
    }

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
      PosColumn(
        text: Formatter.toRupiahDouble(data.total),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.emptyLines(1);
    bytes += generator.text(
      'Terima kasih telah mempercayakan kepada kami!',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(1);
    bytes += generator.feed(3);

    return bytes;
  }

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<BluetoothPrinter?> _loadSavedPrinter() async {
    final prefs = await _ensurePrefs();
    final name = prefs.getString(_printerNameKey);
    final address = prefs.getString(_printerAddressKey);
    if (name != null && address != null) {
      _selectedPrinter = BluetoothPrinter(name: name, address: address);
    } else {
      _selectedPrinter = null;
    }
    return _selectedPrinter;
  }

  Future<void> _autoReconnect(BluetoothPrinter printer) async {
    try {
      if (await PrintBluetoothThermal.connectionStatus) {
        return;
      }
      await PrintBluetoothThermal.connect(macPrinterAddress: printer.address);
    } catch (error) {
      if (kDebugMode) {
        print('Auto reconnect failed: $error');
      }
    }
  }

  Future<bool> _write(List<int> bytes) async {
    try {
      return await PrintBluetoothThermal.writeBytes(bytes);
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print('Failed to write bytes: $error');
      }
      return false;
    }
  }
}
