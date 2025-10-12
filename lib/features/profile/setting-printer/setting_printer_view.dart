import 'package:flutter/material.dart';
import 'package:sales_app/core/services/print_service.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';

class SettingPrinterView extends StatefulWidget {
  const SettingPrinterView({super.key});

  @override
  State<SettingPrinterView> createState() => _SettingPrinterViewState();
}

class _SettingPrinterViewState extends State<SettingPrinterView> {
  final PrintService _printService = PrintService.instance;

  bool _isScanning = false;
  bool _isConnected = false;
  bool _isDisconnecting = false;
  String? _processingAddress;

  BluetoothPrinter? _savedPrinter;
  List<BluetoothPrinter> _availablePrinters = [];

  @override
  void initState() {
    super.initState();
    _initPrinterState();
  }

  Future<void> _initPrinterState() async {
    await _printService.init();
    var saved = await _printService.getSavedPrinter();
    var connected = await _printService.connectionStatus;

    if (!connected && saved != null) {
      connected = await _printService.ensureConnected();
    }

    if (!mounted) return;
    setState(() {
      _savedPrinter = saved;
      _isConnected = connected;
    });
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _availablePrinters = [];
    });

    try {
      final hasPermission = await _printService.hasBluetoothPermission;
      if (!hasPermission) {
        if (!mounted) return;

        // Show permission dialog before requesting
        final shouldRequest = await _showPermissionDialog();
        if (!shouldRequest) {
          _showMessage('Izin Bluetooth diperlukan untuk memindai printer', Colors.red);
          return;
        }

        // Request permission
        final permissionGranted = await _printService.requestBluetoothPermission();
        if (!permissionGranted) {
          if (!mounted) return;
          _showMessage('Izin Bluetooth ditolak. Aktifkan di pengaturan aplikasi.', Colors.red);
          return;
        }
      }

      final enabled = await _printService.isBluetoothEnabled;
      if (!enabled) {
        if (!mounted) return;
        final shouldOpenSettings = await _showBluetoothDialog();
        if (shouldOpenSettings) {
          // You can add code here to open bluetooth settings if needed
          // For now, just show the message
        }
        _showMessage('Aktifkan Bluetooth terlebih dahulu', Colors.orange);
        return;
      }

      final printers = await _printService.scanPrinters();
      if (!mounted) return;
      setState(() {
        _availablePrinters = printers;
      });

      if (printers.isEmpty) {
        _showMessage('Tidak ada printer terdeteksi', Colors.orange);
      }
    } catch (error) {
      if (!mounted) return;
      _showMessage('Gagal memindai printer: $error', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToPrinter(BluetoothPrinter printer) async {
    if (_processingAddress != null || _isDisconnecting) return;

    // Check bluetooth permission before connecting
    final hasPermission = await _printService.hasBluetoothPermission;
    if (!hasPermission) {
      final shouldRequest = await _showPermissionDialog();
      if (!shouldRequest) {
        _showMessage('Izin Bluetooth diperlukan untuk terhubung ke printer', Colors.red);
        return;
      }

      final permissionGranted = await _printService.requestBluetoothPermission();
      if (!permissionGranted) {
        if (!mounted) return;
        _showMessage('Izin Bluetooth ditolak. Aktifkan di pengaturan aplikasi.', Colors.red);
        return;
      }
    }

    // Check if bluetooth is enabled
    final enabled = await _printService.isBluetoothEnabled;
    if (!enabled) {
      if (!mounted) return;
      final shouldOpenSettings = await _showBluetoothDialog();
      if (shouldOpenSettings) {
        // You can add code here to open bluetooth settings if needed
      }
      _showMessage('Aktifkan Bluetooth terlebih dahulu', Colors.orange);
      return;
    }

    setState(() {
      _processingAddress = printer.address;
    });

    final success = await _printService.connectToPrinter(printer);
    final connected = success ? await _printService.connectionStatus : false;

    if (!mounted) return;
    setState(() {
      _processingAddress = null;
      if (success) {
        _savedPrinter = printer;
        _isConnected = connected;
      }
    });

    if (success) {
      _showMessage('Terhubung ke ${printer.name}', Colors.green);
    } else {
      _showMessage('Gagal menghubungkan ke printer', Colors.red);
    }
  }

  Future<void> _disconnectPrinter() async {
    if (_savedPrinter == null || _isDisconnecting) return;

    setState(() {
      _isDisconnecting = true;
    });

    await _printService.disconnect();
    final connected = await _printService.connectionStatus;

    if (!mounted) return;
    setState(() {
      _isDisconnecting = false;
      _isConnected = connected;
    });

    _showMessage('Printer terputus', Colors.orange);
  }

  Future<void> _forgetPrinter() async {
    await _printService.forgetPrinter();
    await _printService.disconnect();

    if (!mounted) return;
    setState(() {
      _savedPrinter = null;
      _isConnected = false;
    });

    _showMessage('Printer tersimpan dihapus', Colors.green);
  }

  Future<void> _printTest() async {
    if (!_isConnected) {
      _showMessage('Hubungkan printer terlebih dahulu', Colors.orange);
      return;
    }

    try {
      await _printService.printReceiptTest();
      if (!mounted) return;
      _showMessage('Test print dikirim', Colors.green);
    } catch (error) {
      if (!mounted) return;
      _showMessage('Gagal melakukan test print: $error', Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Izin Bluetooth Diperlukan'),
                content: const Text(
                  'Aplikasi memerlukan izin Bluetooth untuk memindai dan terhubung ke printer thermal. Apakah Anda ingin memberikan izin?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Izinkan'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> _showBluetoothDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Aktifkan Bluetooth'),
                content: const Text(
                  'Bluetooth perlu diaktifkan untuk menghubungkan printer thermal. Silakan aktifkan Bluetooth di pengaturan perangkat Anda.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Pengaturan'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Setting Printer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScanSection(),
            const SizedBox(height: 20),
            if (_availablePrinters.isNotEmpty) _buildAvailableSection(),
            if (_availablePrinters.isNotEmpty) const SizedBox(height: 20),
            _buildSavedSection(),
            const SizedBox(height: 20),
            _buildTestSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.bluetooth_searching, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Printer Bluetooth',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Cari printer Bluetooth yang tersedia',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              icon:
                  _isScanning
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                      : const Icon(Icons.search, size: 18),
              label: Text(
                _isScanning ? 'Mencari Printer Bluetooth...' : 'Scan Bluetooth',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bluetooth_searching, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Printer Ditemukan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._availablePrinters.map(_buildAvailablePrinterCard),
        ],
      ),
    );
  }

  Widget _buildAvailablePrinterCard(BluetoothPrinter printer) {
    final isSelected = _savedPrinter?.address == printer.address;
    final isBusy = _processingAddress == printer.address;
    final isCurrentConnected = isSelected && _isConnected;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.green.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
        color:
            isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.green.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.print, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printer.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  'MAC: ${printer.address}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  isCurrentConnected ? 'Status: Terhubung' : 'Status: Tersedia',
                  style: TextStyle(
                    fontSize: 11,
                    color: isCurrentConnected ? Colors.green : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isCurrentConnected ? null : () => _connectToPrinter(printer),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child:
                isBusy
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Hubungkan',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.print, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Printer Tersimpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_savedPrinter == null)
            _buildEmptyState('Belum ada printer tersimpan')
          else
            _buildSavedPrinterCard(_savedPrinter!),
        ],
      ),
    );
  }

  Widget _buildSavedPrinterCard(BluetoothPrinter printer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              _isConnected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
        color:
            _isConnected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  printer.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      _isConnected
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _isConnected ? 'Terhubung' : 'Tidak Terhubung',
                  style: TextStyle(
                    fontSize: 10,
                    color: _isConnected ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('MAC: ${printer.address}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _isDisconnecting
                          ? null
                          : _isConnected
                          ? _disconnectPrinter
                          : () => _connectToPrinter(printer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConnected ? Colors.orange : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child:
                      _isDisconnecting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                          : Text(
                            _isConnected ? 'Putuskan' : 'Hubungkan',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _isDisconnecting ? null : _forgetPrinter,
                child: const Text('Lupakan', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.print_disabled, color: Colors.grey[400], size: 40),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.print_outlined, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test Print', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      'Uji coba print untuk memastikan printer bekerja',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isConnected ? _printTest : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              icon: const Icon(Icons.print, size: 18),
              label: const Text(
                'Print Test Page',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
