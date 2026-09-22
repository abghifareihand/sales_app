import 'package:flutter/material.dart';
import 'package:sales_app/core/services/print_service.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_dialog.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

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

        final shouldRequest = await _showPermissionDialog();
        if (!shouldRequest) {
          _showError('Izin Bluetooth diperlukan untuk memindai printer');
          return;
        }

        final permissionGranted = await _printService.requestBluetoothPermission();
        if (!permissionGranted) {
          if (!mounted) return;
          _showError('Izin Bluetooth ditolak. Aktifkan di pengaturan aplikasi.');
          return;
        }
      }

      final enabled = await _printService.isBluetoothEnabled;
      if (!enabled) {
        if (!mounted) return;
        await _showBluetoothDialog();
        _showWarning('Aktifkan Bluetooth terlebih dahulu');
        return;
      }

      final printers = await _printService.scanPrinters();
      if (!mounted) return;
      setState(() {
        _availablePrinters = printers;
      });

      if (printers.isEmpty) {
        _showWarning('Tidak ada printer terdeteksi di sekitar');
      }
    } catch (error) {
      if (!mounted) return;
      _showError('Gagal memindai printer: $error');
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

    final hasPermission = await _printService.hasBluetoothPermission;
    if (!hasPermission) {
      final shouldRequest = await _showPermissionDialog();
      if (!shouldRequest) {
        _showError('Izin Bluetooth diperlukan untuk terhubung ke printer');
        return;
      }

      final permissionGranted = await _printService.requestBluetoothPermission();
      if (!permissionGranted) {
        if (!mounted) return;
        _showError('Izin Bluetooth ditolak. Aktifkan di pengaturan aplikasi.');
        return;
      }
    }

    final enabled = await _printService.isBluetoothEnabled;
    if (!enabled) {
      if (!mounted) return;
      await _showBluetoothDialog();
      _showWarning('Aktifkan Bluetooth terlebih dahulu');
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
      _showSuccess('Berhasil terhubung ke ${printer.name}');
    } else {
      _showError('Gagal menghubungkan ke printer');
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

    _showWarning('Koneksi printer terputus');
  }

  Future<void> _forgetPrinter() async {
    await _printService.forgetPrinter();
    await _printService.disconnect();

    if (!mounted) return;
    setState(() {
      _savedPrinter = null;
      _isConnected = false;
    });

    _showSuccess('Printer tersimpan berhasil dihapus');
  }

  Future<void> _printTest() async {
    if (!_isConnected) {
      _showWarning('Hubungkan printer terlebih dahulu sebelum test print');
      return;
    }

    try {
      await _printService.printReceiptTest();
      if (!mounted) return;
      _showSuccess('Sample test print berhasil dikirim ke printer');
    } catch (error) {
      if (!mounted) return;
      _showError('Gagal melakukan test print: $error');
    }
  }

  void _showSuccess(String msg) {
    if (mounted) CustomSnackbar.showSuccess(context, msg);
  }

  void _showError(String msg) {
    if (mounted) CustomSnackbar.showError(context, msg);
  }

  void _showWarning(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<bool> _showPermissionDialog() async {
    final res = await CustomConfirmationDialog.show(
      context,
      icon: Icons.bluetooth_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.primaryLight.withValues(alpha: 0.35),
      title: 'Izin Bluetooth Diperlukan',
      message: 'Aplikasi memerlukan izin Bluetooth untuk memindai dan terhubung ke printer thermal saat mencetak struk transaksi.',
      confirmLabel: 'Berikan Izin',
      cancelLabel: 'Batal',
    );
    return res ?? false;
  }

  Future<bool> _showBluetoothDialog() async {
    final res = await CustomConfirmationDialog.show(
      context,
      icon: Icons.bluetooth_disabled_rounded,
      iconColor: const Color(0xFFD97706),
      iconBgColor: const Color(0xFFFEF3C7),
      title: 'Aktifkan Bluetooth',
      message: 'Bluetooth perangkat belum aktif. Silakan aktifkan Bluetooth agar dapat terhubung dengan printer thermal.',
      confirmLabel: 'Buka Pengaturan',
      cancelLabel: 'Batal',
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Pengaturan Printer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Banner Card
            _buildStatusHeader(),
            const SizedBox(height: 20),

            // 2. Scan Bluetooth Section
            _buildScanSection(),
            const SizedBox(height: 20),

            // 3. Available Printers (if found)
            if (_availablePrinters.isNotEmpty) ...[
              _buildAvailableSection(),
              const SizedBox(height: 20),
            ],

            // 4. Saved Printer Section
            _buildSavedSection(),
            const SizedBox(height: 20),

            // 5. Test Print Section
            _buildTestSection(),
          ],
        ),
      ),
    );
  }

  // Header Banner showing current status
  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF7ED),
            const Color(0xFFFFEDD5).withValues(alpha: 0.5),
            AppColors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE8D6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: _isConnected
                  ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                  : AppColors.amberGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (_isConnected ? const Color(0xFF10B981) : AppColors.primary).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _isConnected ? Icons.print_rounded : Icons.print_disabled_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isConnected ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isConnected ? 'Printer Terhubung' : 'Belum Ada Koneksi',
                      style: TextStyle(
                        color: _isConnected ? const Color(0xFF059669) : const Color(0xFFB45309),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _isConnected && _savedPrinter != null
                      ? _savedPrinter!.name
                      : 'Printer Thermal 58mm',
                  style: AppFonts.bold.copyWith(
                    color: AppColors.slate900,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isConnected
                      ? 'Siap mencetak struk transaksi penjualan'
                      : 'Scan Bluetooth untuk menghubungkan printer',
                  style: AppFonts.regular.copyWith(
                    color: AppColors.slate500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Scan Bluetooth Section
  Widget _buildScanSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bluetooth_searching_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pindai Perangkat',
                      style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                    ),
                    Text(
                      'Cari printer Bluetooth yang siap dihubungkan',
                      style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: _isScanning ? null : AppColors.amberGradient,
              color: _isScanning ? AppColors.slate100 : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isScanning
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isScanning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : const Icon(Icons.search_rounded, size: 20, color: Colors.white),
              label: Text(
                _isScanning ? 'Mencari Printer...' : 'Mulai Pindai Bluetooth',
                style: TextStyle(
                  color: _isScanning ? AppColors.slate500 : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Available Printers Section
  Widget _buildAvailableSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Icon(Icons.devices_rounded, color: Color(0xFF16A34A), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Printer Ditemukan (${_availablePrinters.length})',
                  style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                ),
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrentConnected
            ? const Color(0xFFF0FDF4)
            : (isSelected ? const Color(0xFFFFFBEB) : AppColors.slate50),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentConnected
              ? const Color(0xFF86EFAC)
              : (isSelected ? const Color(0xFFFDE68A) : AppColors.slate200),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrentConnected
                  ? const Color(0xFFDCFCE7)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrentConnected ? const Color(0xFF86EFAC) : AppColors.slate200,
              ),
            ),
            child: Icon(
              Icons.print_rounded,
              color: isCurrentConnected ? const Color(0xFF16A34A) : AppColors.slate700,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printer.name,
                  style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'MAC: ${printer.address}',
                  style: const TextStyle(fontSize: 11, color: AppColors.slate500, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: isCurrentConnected ? null : () => _connectToPrinter(printer),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentConnected ? const Color(0xFF16A34A) : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: isBusy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    isCurrentConnected ? 'Terhubung' : 'Hubungkan',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  // Saved Printer Section
  Widget _buildSavedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: AppColors.primaryLight.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bookmark_added_rounded, color: AppColors.primaryDark, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Printer Tersimpan',
                style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_savedPrinter == null)
            _buildEmptyState('Belum ada printer yang tersimpan di aplikasi.')
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
        color: _isConnected ? const Color(0xFFF0FDF4) : AppColors.slate50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isConnected ? const Color(0xFF86EFAC) : AppColors.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      printer.name,
                      style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'MAC: ${printer.address}',
                      style: const TextStyle(fontSize: 11, color: AppColors.slate500, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isConnected ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isConnected ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _isConnected ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isConnected ? 'Terhubung' : 'Terputus',
                      style: TextStyle(
                        fontSize: 11,
                        color: _isConnected ? const Color(0xFF16A34A) : const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isDisconnecting
                      ? null
                      : _isConnected
                          ? _disconnectPrinter
                          : () => _connectToPrinter(printer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConnected ? const Color(0xFFEA580C) : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: _isDisconnecting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _isConnected ? Icons.link_off_rounded : Icons.link_rounded,
                          size: 18,
                        ),
                  label: Text(
                    _isConnected ? 'Putuskan Koneksi' : 'Hubungkan Kembali',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _isDisconnecting ? null : _forgetPrinter,
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                label: const Text(
                  'Lupakan',
                  style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color(0xFFFEF2F2),
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.print_disabled_outlined, color: AppColors.slate400, size: 32),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Test Print Section
  Widget _buildTestSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFD97706), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uji Coba Cetak (Test Print)',
                      style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                    ),
                    Text(
                      'Pastikan kertas thermal dan koneksi printer bekerja',
                      style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              gradient: _isConnected ? AppColors.amberGradient : null,
              color: _isConnected ? null : AppColors.slate100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isConnected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton.icon(
              onPressed: _isConnected ? _printTest : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(
                Icons.print_rounded,
                size: 18,
                color: _isConnected ? Colors.white : AppColors.slate400,
              ),
              label: Text(
                _isConnected ? 'Cetak Sample Struk Penjualan' : 'Printer Belum Terhubung',
                style: TextStyle(
                  color: _isConnected ? Colors.white : AppColors.slate400,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
