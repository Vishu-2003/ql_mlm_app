import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/core/models/models_helper.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@Freezed(toJson: false)
class GetNotificationModel with _$GetNotificationModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetNotificationModel({
    @JsonKey(name: 'name') String? id,
    String? time,
    String? subject,
    String? message,
    DateTime? creation,
    @FlagConverter() required bool notificationRead,
  }) = _GetNotificationModel;

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationModelFromJson(json);
}
