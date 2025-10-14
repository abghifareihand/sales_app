import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductResponse {
  const ProductResponse({required this.status, required this.message, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) => _$ProductResponseFromJson(json);

  final bool status;
  final String message;
  final List<Product> products;

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
  const Product({
    this.stockId,
    this.id,
    this.name,
    this.provider,
    this.category,
    this.kuota,
    this.description,
    this.costPrice,
    this.sellingPrice,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  final int? stockId;
  final int? id;
  final String? name;
  final String? provider;
  final String? category;
  final String? kuota;
  final String? description;
  final int? quantity;
  @JsonKey(fromJson: _stringToDouble)
  final double? costPrice;
  @JsonKey(fromJson: _stringToDouble)
  final double? sellingPrice;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Helper function untuk parse string ke double
  static double _stringToDouble(String? value) => double.tryParse(value ?? '0') ?? 0;
}
