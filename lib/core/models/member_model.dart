import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/core/models/models.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

class PostRegisterMemberModel {
  final String email;
  final String mobile;
  final String currency;
  final String password;
  final String memberName;
  final String accountType;
  // Attachment is required for all account types except Personal
  final PlatformFile? attachment;
  final String referralNameOrCode;

  PostRegisterMemberModel({
    this.attachment,
    required this.email,
    required this.mobile,
    required this.currency,
    required this.password,
    required this.accountType,
    required this.memberName,
    required this.referralNameOrCode,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap(<String, dynamic>{
      'email': email,
      'mobile': mobile,
      'currency': currency,
      'password': password,
      'member_name': memberName,
      'account_type': accountType,
      'sponser_name': referralNameOrCode,
      if (accountType != 'Personal')
        'file': await MultipartFile.fromFile(
          attachment!.path!,
          filename: attachment!.name,
        ),
    });
  }

  @override
  String toString() {
    return 'PostRegisterMemberModel(referralNameOrCode: $referralNameOrCode, password: $password, accountType: $accountType, memberName: $memberName, email: $email, mobile: $mobile, currency: $currency)';
  }
}

@Freezed(copyWith: false, toJson: false, equal: false)
class GetProfileModel with _$GetProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetProfileModel({
    String? name,
    String? email,
    String? mobile,
    String? gender,
    String? user,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? currency,
    String? bankName,
    String? username,
    String? ifscCode,
    String? lastName,
    String? memberName,
    String? firstName,
    String? namingSeries,
    String? occupation,
    String? profilePhoto,
    String? nationality,
    String? accountType,
    String? incomeRange,
    String? industryType,
    String? sponserName,
    String? dateOfBirth,
    String? currentBadge,
    String? payoutSettings,
    String? accountNumber,
    String? sourceOfIncome,
    String? bankAccountHolderName,
    @FlagConverter() required bool accountClosed,
    @JsonKey(name: 'address_line_1') String? addressLine1,
    @JsonKey(name: 'address_line_2') String? addressLine2,
    @FlagConverter() required bool twoFactorAuthentication,
  }) = _GetProfileModel;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => _$GetProfileModelFromJson(json);
}

@Freezed(copyWith: false, equal: false)
class UpdateProfileModel with _$UpdateProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UpdateProfileModel({
    required String name,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String memberName,
    required String occupation,
    required String nationality,
    required String incomeRange,
    required String industryType,
    required String sourceOfIncome,
    @DateConverter() required DateTime? dateOfBirth,
    @FlagConverter() required bool twoFactorAuthentication,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') required String addressLine2,
  }) = _UpdateProfileModel;

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileModelFromJson(json);
}

@Freezed(copyWith: false, equal: false)
class UpdateBankModel with _$UpdateBankModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UpdateBankModel({
    required String name,
    required String bankName,
    required String ifscCode,
    required String accountNumber,
    required String bankAccountHolderName,
  }) = _UpdateBankModel;

  factory UpdateBankModel.fromJson(Map<String, dynamic> json) => _$UpdateBankModelFromJson(json);
}
