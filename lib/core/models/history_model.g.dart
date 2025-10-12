// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryResponse _$HistoryResponseFromJson(Map<String, dynamic> json) =>
    HistoryResponse(
      status: json['status'] as bool,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$HistoryResponseToJson(HistoryResponse instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

History _$HistoryFromJson(Map<String, dynamic> json) => History(
  productName: json['product_name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  from: json['from'] as String,
  to: json['to'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
  'product_name': instance.productName,
  'quantity': instance.quantity,
  'from': instance.from,
  'to': instance.to,
  'type': instance.type,
  'status': instance.status,
  'created_at': instance.createdAt,
};
