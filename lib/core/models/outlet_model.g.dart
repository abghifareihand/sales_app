// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outlet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutletResponse _$OutletResponseFromJson(Map<String, dynamic> json) =>
    OutletResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      outlets:
          (json['outlets'] as List<dynamic>)
              .map((e) => Outlet.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$OutletResponseToJson(OutletResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'outlets': instance.outlets,
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
};
