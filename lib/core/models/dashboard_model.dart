import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/core/models/models_helper.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@Freezed(toJson: false)
class GetDashboardModel with _$GetDashboardModel {
  @JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
  const factory GetDashboardModel({
    String? referralLink,
    int? totalIntroducter,
    String? totalMemberTrade,
    String? totalPersonalTrade,
    String? totalCommission,
    String? totalWithdrawals,
    String? totalDeposits,
    String? baseTotalMemberTrade,
    String? baseTotalPersonalTrade,
    String? baseTotalCommission,
    String? baseTotalWithdrawals,
    String? baseTotalDeposits,
    String? goldPrice,
    double? goldPriceValue,
    String? goldPriceUsd,
    double? goldPriceUsdValue,
    String? kycStatus,
    String? kycMessage,
    String? marketTime,
    dynamic exchangeRate,
    @FlagConverter() required bool openNotificationLog,
    GetDashboardSettingsModel? settings,
  }) = _GetDashboardModel;

  factory GetDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$GetDashboardModelFromJson(json);
}

@Freezed(toJson: false, copyWith: false)
class GetDashboardSettingsModel with _$GetDashboardSettingsModel {
  @JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
  const factory GetDashboardSettingsModel({
    String? stripeKey,
    int? withdrawalFees,
    int? marketClose,
  }) = _GetDashboardSettingsModel;

  factory GetDashboardSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$GetDashboardSettingsModelFromJson(json);
}
