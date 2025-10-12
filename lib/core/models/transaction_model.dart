import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionResponse {
  const TransactionResponse({
    required this.status,
    required this.message,
    required this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  final bool status;
  final String message;
  final List<Transaction> transactions;

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction {
  const Transaction({
    required this.id,
    required this.status,
    required this.sales,
    required this.outlet,
    this.originalTotal,
    this.originalProfit,
    required this.total,
    required this.profit,
    required this.createdAt,
    required this.items,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  final int id;
  final String status;
  final String sales;
  final Outlet outlet;

  @JsonKey(fromJson: _stringToDouble)
  final double? originalTotal;

  @JsonKey(fromJson: _stringToDouble)
  final double? originalProfit;

  @JsonKey(fromJson: _stringToDouble)
  final double total;

  @JsonKey(fromJson: _stringToDouble)
  final double profit;

  final String createdAt;
  final List<TransactionItem> items;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  static double _stringToDouble(String? value) =>
      double.tryParse(value ?? '0') ?? 0;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Outlet {
  const Outlet({
    required this.id,
    required this.name,
    required this.nameOutlet,
    required this.addressOutlet,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);

  final int id;
  final String name;
  final String nameOutlet;
  final String addressOutlet;

  Map<String, dynamic> toJson() => _$OutletToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.costPrice,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  final int id;
  final int productId;
  final String name;
  final int quantity;

  @JsonKey(fromJson: _stringToDouble)
  final double price;

  @JsonKey(fromJson: _stringToDouble)
  final double costPrice;

  final double subtotal;

  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);

  static double _stringToDouble(String? value) =>
      double.tryParse(value ?? '0') ?? 0;
}
