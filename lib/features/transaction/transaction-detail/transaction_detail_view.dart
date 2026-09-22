import 'package:flutter/material.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/core/services/print_service.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_dotted.dart';
import 'package:sales_app/ui/shared/custom_receipt.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class TransactionDetailView extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetailView({super.key, required this.transaction});

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final PrintService _printService = PrintService.instance;
  bool _isPrinting = false;

  Future<void> _handlePrint() async {
    if (_isPrinting) return;

    // Minta input uang pembeli dulu
    final moneyController = TextEditingController();
    final double total = widget.transaction.total;

    final bayar = await showDialog<double>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF16A34A).withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.payments_rounded, color: Color(0xFF16A34A), size: 30),
                ),
                const SizedBox(height: 16),
                Text(
                  'Input Uang Pembeli',
                  style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 17),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    'Total: ${Formatter.toRupiahDouble(total)}',
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: moneyController,
                  keyboardType: TextInputType.number,
                  label: 'Nominal Uang Diterima',
                  hintText: 'Masukkan jumlah uang',
                  prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary, size: 20),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ActionChip(
                    avatar: const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.primary),
                    label: const Text('Uang Pas', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.slate700)),
                    backgroundColor: AppColors.slate50,
                    side: const BorderSide(color: AppColors.slate200),
                    onPressed: () {
                      moneyController.text = total.toInt().toString();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.slate300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: AppColors.slate50,
                          ),
                          child: const Text('Batal', style: TextStyle(color: AppColors.slate600, fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.amberGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              final value = double.tryParse(
                                moneyController.text.replaceAll('.', '').replaceAll(',', ''),
                              );
                              if (value == null || value < total) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Uang pembeli kurang dari total tagihan'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }
                              Navigator.pop(ctx, value);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cetak Struk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (bayar == null) return; // batal input

    setState(() {
      _isPrinting = true;
    });

    try {
      final double kembalian = bayar - total;
      await _printService.printReceipt(widget.transaction, bayar: bayar, kembalian: kembalian);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Struk berhasil dicetak'), backgroundColor: Colors.green),
      );
    } on PrintServiceException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message), backgroundColor: Colors.red));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak struk: $error'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Transaksi Struk'),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: ClipShadowPath(
            clipper: ReceiptClipper(),
            shadow: Shadow(blurRadius: 8, color: AppColors.black.withValues(alpha: 0.1)),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    widget.transaction.sales.toUpperCase(),
                    style: AppFonts.bold.copyWith(color: AppColors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.transaction.outlet.nameOutlet,
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.transaction.outlet.addressOutlet,
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    Formatter.toDateTimeFull(widget.transaction.createdAt),
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  const DottedDivider(),
                  const SizedBox(height: 8.0),
                  Column(
                    children:
                        widget.transaction.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.name}|${item.provider}',
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                    height: 1.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${item.category}|${item.kuota}',
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                    height: 1.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${Formatter.toNoRupiahDouble(item.price)} x ${item.quantity}',
                                        style: AppFonts.regular.copyWith(
                                          color: AppColors.black,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      Formatter.toNoRupiahDouble(item.subtotal),
                                      style: AppFonts.regular.copyWith(
                                        color: AppColors.black,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                  const DottedDivider(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                      ),
                      Text(
                        Formatter.toRupiahDouble(widget.transaction.total),
                        style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Terima kasih telah mempercayakan kepada kami!',
                      style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Button.filled(
          onPressed: _isPrinting ? null : _handlePrint,
          label: 'Cetak Transaksi',
          isLoading: _isPrinting,
        ),
      ),
    );
  }
}
