import 'package:json_annotation/json_annotation.dart';

part 'add_outlet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddOutletRequest {
  const AddOutletRequest({
    required this.idOutlet,
    required this.nameOutlet,
    required this.addressOutlet,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory AddOutletRequest.fromJson(Map<String, dynamic> json) =>
      _$AddOutletRequestFromJson(json);

  final String idOutlet;
  final String nameOutlet;
  final String addressOutlet;
  final String name;
  final String phone;
  final String latitude;
  final String longitude;

  Map<String, dynamic> toJson() => _$AddOutletRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class AddOutletResponse {
  const AddOutletResponse({
    required this.status,
    required this.message,
    required this.outlet,
  });

  factory AddOutletResponse.fromJson(Map<String, dynamic> json) =>
      _$AddOutletResponseFromJson(json);

  final bool status;
  final String message;
  final Outlet outlet;

  Map<String, dynamic> toJson() => _$AddOutletResponseToJson(this);
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
    this.createdAt,
    this.updatedAt,
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
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$OutletToJson(this);
}