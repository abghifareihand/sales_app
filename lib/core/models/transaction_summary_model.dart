import 'package:json_annotation/json_annotation.dart';

part 'transaction_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionSummaryResponse {
  const TransactionSummaryResponse({
    required this.status,
    required this.message,
    required this.summary,
  });

  factory TransactionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryResponseFromJson(json);

  final bool status;
  final String message;
  final TransactionSummary summary;

  Map<String, dynamic> toJson() => _$TransactionSummaryResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionSummary {
  const TransactionSummary({
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryFromJson(json);

  final SummaryDetail daily;
  final SummaryDetail weekly;
  final SummaryDetail monthly;

  Map<String, dynamic> toJson() => _$TransactionSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SummaryDetail {
  const SummaryDetail({
    required this.total,
    required this.profit,
  });

  factory SummaryDetail.fromJson(Map<String, dynamic> json) =>
      _$SummaryDetailFromJson(json);

  @JsonKey(fromJson: _stringToDouble)
  final double total;

  @JsonKey(fromJson: _stringToDouble)
  final double profit;

  Map<String, dynamic> toJson() => _$SummaryDetailToJson(this);

  static double _stringToDouble(String? value) =>
      double.tryParse(value ?? '0') ?? 0;
}
