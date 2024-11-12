import 'package:freezed_annotation/freezed_annotation.dart';

part 'beneficiery_models.freezed.dart';
part 'beneficiery_models.g.dart';

@Freezed(toJson: false)
class GetBeneficiaryModel with _$GetBeneficiaryModel {
  const factory GetBeneficiaryModel({
    String? name,
    String? status,
    @JsonKey(name: 'beneficiary_name') String? beneficiaryName,
    @JsonKey(name: 'beneficiary_member') String? beneficiaryMember,
    @JsonKey(name: 'beneficiary_email') String? beneficiaryEmail,
  }) = _BeneficieryModel;

  factory GetBeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$GetBeneficiaryModelFromJson(json);
}

@Freezed()
class PostBeneficiaryModel with _$PostBeneficiaryModel {
  const factory PostBeneficiaryModel({
    @JsonKey(name: 'beneficiary_name') String? beneficiaryName,
    @JsonKey(name: 'beneficiary_member') String? beneficiaryMember,
    @JsonKey(name: 'beneficiary_email') String? beneficiaryEmail,
  }) = _PostBeneficieryModel;

  factory PostBeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$PostBeneficiaryModelFromJson(json);
}

@Freezed()
class UpdateBeneficiaryModel with _$UpdateBeneficiaryModel {
  const factory UpdateBeneficiaryModel({
    String? name,
    @JsonKey(name: 'beneficiary_email') String? beneficiaryEmail,
  }) = _UpdateBeneficieryModel;

  factory UpdateBeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateBeneficiaryModelFromJson(json);
}
