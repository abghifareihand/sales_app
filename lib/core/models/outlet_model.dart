import 'package:json_annotation/json_annotation.dart';

part 'outlet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OutletResponse {
  const OutletResponse({
    required this.status,
    required this.message,
    required this.outlets,
  });

  factory OutletResponse.fromJson(Map<String, dynamic> json) =>
      _$OutletResponseFromJson(json);

  final bool status;
  final String message;
  final List<Outlet> outlets;

  Map<String, dynamic> toJson() => _$OutletResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Outlet {
  const Outlet({
    this.id,
    this.createdBy,
    this.idOutlet,
    this.nameOutlet,
    this.addressOutlet,
    this.name,
    this.phone,
    this.latitude,
    this.longitude,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) =>
      _$OutletFromJson(json);

  final int? id;
  final int? createdBy;
  final String? idOutlet;
  final String? nameOutlet;
  final String? addressOutlet;
  final String? name;
  final String? phone;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toJson() => _$OutletToJson(this);
}
