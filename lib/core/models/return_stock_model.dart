import 'package:json_annotation/json_annotation.dart';

part 'return_stock_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnStockRequest {
  final int stockId;
  final int quantity;
  final String? notes;

  ReturnStockRequest({
    required this.stockId,
    required this.quantity,
    this.notes,
  });

  factory ReturnStockRequest.fromJson(Map<String, dynamic> json) =>
      _$ReturnStockRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnStockRequestToJson(this);
}
