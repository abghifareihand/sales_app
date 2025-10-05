// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnStockRequest _$ReturnStockRequestFromJson(Map<String, dynamic> json) =>
    ReturnStockRequest(
      stockId: (json['stock_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReturnStockRequestToJson(ReturnStockRequest instance) =>
    <String, dynamic>{
      'stock_id': instance.stockId,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };
