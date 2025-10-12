import 'package:flutter/material.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/core/services/print_service.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_dotted.dart';
import 'package:sales_app/ui/shared/custom_receipt.dart';
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

    setState(() {
      _isPrinting = true;
    });

    try {
      await _printService.printReceipt(widget.transaction);
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
                                  item.name,
                                  style: AppFonts.semiBold.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
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
                        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                      ),
                      Text(
                        Formatter.toRupiahDouble(widget.transaction.total),
                        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
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
