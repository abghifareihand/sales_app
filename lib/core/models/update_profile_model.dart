import 'package:json_annotation/json_annotation.dart';

part 'update_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateProfileRequest {
  final String name;
  final String username;

  UpdateProfileRequest({
    required this.name,
    required this.username,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
