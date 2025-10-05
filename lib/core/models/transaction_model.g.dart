// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      transactions:
          (json['transactions'] as List<dynamic>)
              .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$TransactionResponseToJson(
  TransactionResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'transactions': instance.transactions,
};

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  outlet: Outlet.fromJson(json['outlet'] as Map<String, dynamic>),
  originalTotal: Transaction._stringToDouble(json['original_total'] as String?),
  originalProfit: Transaction._stringToDouble(
    json['original_profit'] as String?,
  ),
  total: Transaction._stringToDouble(json['total'] as String?),
  profit: Transaction._stringToDouble(json['profit'] as String?),
  createdAt: json['created_at'] as String,
  items:
      (json['items'] as List<dynamic>)
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'outlet': instance.outlet,
      'original_total': instance.originalTotal,
      'original_profit': instance.originalProfit,
      'total': instance.total,
      'profit': instance.profit,
      'created_at': instance.createdAt,
      'items': instance.items,
    };

Outlet _$OutletFromJson(Map<String, dynamic> json) => Outlet(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nameOutlet: json['name_outlet'] as String,
  addressOutlet: json['address_outlet'] as String,
);

Map<String, dynamic> _$OutletToJson(Outlet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_outlet': instance.nameOutlet,
  'address_outlet': instance.addressOutlet,
};

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: TransactionItem._stringToDouble(json['price'] as String?),
      costPrice: TransactionItem._stringToDouble(json['cost_price'] as String?),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'cost_price': instance.costPrice,
      'subtotal': instance.subtotal,
    };
