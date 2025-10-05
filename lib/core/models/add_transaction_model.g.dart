// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTransactionRequest _$AddTransactionRequestFromJson(
  Map<String, dynamic> json,
) => AddTransactionRequest(
  outletId: (json['outlet_id'] as num).toInt(),
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  items:
      (json['items'] as List<dynamic>)
          .map(
            (e) => TransactionItemRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$AddTransactionRequestToJson(
  AddTransactionRequest instance,
) => <String, dynamic>{
  'outlet_id': instance.outletId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'items': instance.items,
};

TransactionItemRequest _$TransactionItemRequestFromJson(
  Map<String, dynamic> json,
) => TransactionItemRequest(
  productId: (json['product_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$TransactionItemRequestToJson(
  TransactionItemRequest instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'quantity': instance.quantity,
};
