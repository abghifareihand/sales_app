import 'package:json_annotation/json_annotation.dart';

part 'update_password_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdatePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;


  UpdatePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordRequestToJson(this);
}
