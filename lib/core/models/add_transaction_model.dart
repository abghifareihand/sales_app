import 'package:json_annotation/json_annotation.dart';

part 'add_transaction_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddTransactionRequest {
  const AddTransactionRequest({
    required this.outletId,
    required this.latitude,
    required this.longitude,
    required this.items,
  });

  factory AddTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$AddTransactionRequestFromJson(json);

  final int outletId;
  final String latitude;
  final String longitude;
  final List<TransactionItemRequest> items;

  Map<String, dynamic> toJson() => _$AddTransactionRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionItemRequest {
  const TransactionItemRequest({
    required this.productId,
    required this.quantity,
  });

  factory TransactionItemRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemRequestFromJson(json);

  final int productId;
  final int quantity;

  Map<String, dynamic> toJson() => _$TransactionItemRequestToJson(this);
}