// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSummaryResponse _$TransactionSummaryResponseFromJson(
  Map<String, dynamic> json,
) => TransactionSummaryResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
  summary: TransactionSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionSummaryResponseToJson(
  TransactionSummaryResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'summary': instance.summary,
};

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    TransactionSummary(
      daily: SummaryDetail.fromJson(json['daily'] as Map<String, dynamic>),
      weekly: SummaryDetail.fromJson(json['weekly'] as Map<String, dynamic>),
      monthly: SummaryDetail.fromJson(json['monthly'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionSummaryToJson(TransactionSummary instance) =>
    <String, dynamic>{
      'daily': instance.daily,
      'weekly': instance.weekly,
      'monthly': instance.monthly,
    };

SummaryDetail _$SummaryDetailFromJson(Map<String, dynamic> json) =>
    SummaryDetail(
      total: (json['total'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
    );

Map<String, dynamic> _$SummaryDetailToJson(SummaryDetail instance) =>
    <String, dynamic>{'total': instance.total, 'profit': instance.profit};
