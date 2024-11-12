import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/core/models/models_helper.dart';

part 'gold_convert_repayment_terminate_model.freezed.dart';
part 'gold_convert_repayment_terminate_model.g.dart';

@Freezed(toJson: false, copyWith: false)
class GetTerminateGoldConvertModel with _$GetTerminateGoldConvertModel {
  @JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
  const factory GetTerminateGoldConvertModel({
    @JsonKey(name: "name") required String id,
    String? status,
    String? qmMember,
    double? amountDifference,
    dynamic amountDifferenceLabel,
    required String qmConvertOrder,
    @FlagConverter() required bool pay,
    @FlagConverter() required bool receive,
    @Default([])
    List<GetGoldConvertTerminateRequestDetailsModel> qmGoldConvertTerminateRequestDetails,
  }) = _GetTerminateGoldConvertModel;

  factory GetTerminateGoldConvertModel.fromJson(Map<String, dynamic> json) =>
      _$GetTerminateGoldConvertModelFromJson(json);
}

@Freezed(copyWith: false)
class GetGoldConvertTerminateRequestDetailsModel with _$GetGoldConvertTerminateRequestDetailsModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetGoldConvertTerminateRequestDetailsModel({
    @JsonKey(name: "name") required String id,
    dynamic key,
    dynamic value,
  }) = _GetGoldConvertTerminateRequestDetailsModel;

  factory GetGoldConvertTerminateRequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GetGoldConvertTerminateRequestDetailsModelFromJson(json);
}
