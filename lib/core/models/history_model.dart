import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HistoryResponse {
  const HistoryResponse({
    required this.status,
    required this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseFromJson(json);

  final bool status;
  final List<History> data;

  Map<String, dynamic> toJson() => _$HistoryResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class History {
  const History({
    required this.productName,
    required this.quantity,
    required this.from,
    required this.to,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  final String productName;
  final int quantity;
  final String from;
  final String to;
  final String type;
  final String status;
  final String createdAt; // bisa juga DateTime jika ingin parsing langsung

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
