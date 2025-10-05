// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      products:
          (json['products'] as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  stockId: (json['stock_id'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  costPrice: Product._stringToDouble(json['cost_price'] as String?),
  sellingPrice: Product._stringToDouble(json['selling_price'] as String?),
  quantity: (json['quantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'stock_id': instance.stockId,
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cost_price': instance.costPrice,
  'selling_price': instance.sellingPrice,
  'quantity': instance.quantity,
};
