// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_outlet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOutletRequest _$AddOutletRequestFromJson(Map<String, dynamic> json) =>
    AddOutletRequest(
      idOutlet: json['id_outlet'] as String,
      nameOutlet: json['name_outlet'] as String,
      addressOutlet: json['address_outlet'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$AddOutletRequestToJson(AddOutletRequest instance) =>
    <String, dynamic>{
      'id_outlet': instance.idOutlet,
      'name_outlet': instance.nameOutlet,
      'address_outlet': instance.addressOutlet,
      'name': instance.name,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

AddOutletResponse _$AddOutletResponseFromJson(Map<String, dynamic> json) =>
    AddOutletResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      outlet: Outlet.fromJson(json['outlet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddOutletResponseToJson(AddOutletResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'outlet': instance.outlet,
    };

Outlet _$OutletFromJson(Map<String, dynamic> json) => Outlet(
  id: (json['id'] as num?)?.toInt(),
  createdBy: (json['created_by'] as num?)?.toInt(),
  idOutlet: json['id_outlet'] as String?,
  nameOutlet: json['name_outlet'] as String?,
  addressOutlet: json['address_outlet'] as String?,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$OutletToJson(Outlet instance) => <String, dynamic>{
  'id': instance.id,
  'created_by': instance.createdBy,
  'id_outlet': instance.idOutlet,
  'name_outlet': instance.nameOutlet,
  'address_outlet': instance.addressOutlet,
  'name': instance.name,
  'phone': instance.phone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
