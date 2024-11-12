import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

class GetWalletModel {
  QmCashWallet? qmCashWallet;
  QmGcaWallet? qmGcaWallet;
  QmGsaWallet? qmGsaWallet;
  QmPayoutAccount? qmPayoutAccount;
  String? payoutSetting;
  List<PayoutSettingsModel>? payoutSettings;

  GetWalletModel({
    this.qmCashWallet,
    this.qmGcaWallet,
    this.qmGsaWallet,
    this.qmPayoutAccount,
    this.payoutSetting,
    this.payoutSettings,
  });

  GetWalletModel.fromJson(Map<String, dynamic> json) {
    qmCashWallet =
        json['qm_cash_wallet'] != null ? QmCashWallet.fromJson(json['qm_cash_wallet']) : null;
    qmGcaWallet =
        json['qm_gca_wallet'] != null ? QmGcaWallet.fromJson(json['qm_gca_wallet']) : null;
    qmGsaWallet =
        json['qm_gsa_wallet'] != null ? QmGsaWallet.fromJson(json['qm_gsa_wallet']) : null;
    qmPayoutAccount = json['qm_payout_account'] != null
        ? QmPayoutAccount.fromJson(json['qm_payout_account'])
        : null;
    payoutSettings = json['payout_settings'] != null
        ? (json['payout_settings'] as List).map((i) => PayoutSettingsModel.fromJson(i)).toList()
        : [];
    payoutSetting = json['payout_setting'];
  }

  @override
  String toString() {
    return 'GetWalletModel(qmCashWallet: $qmCashWallet, qmGcaWallet: $qmGcaWallet, qmGsaWallet: $qmGsaWallet, qmPayoutAccount: $qmPayoutAccount, payoutSetting: $payoutSetting, payoutSettings: $payoutSettings)';
  }
}

@Freezed(toJson: false)
class QmCashWallet with _$QmCashWallet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory QmCashWallet({
    String? name,
    String? member,
    String? cashBalanceInCurrency,
    double? cashBalanceInCurrencyVal,
    String? baseCashBalanceInCurrency,
  }) = _QmCashWallet;

  factory QmCashWallet.fromJson(Map<String, dynamic> json) => _$QmCashWalletFromJson(json);
}

@Freezed(toJson: false)
class QmGcaWallet with _$QmGcaWallet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory QmGcaWallet({
    String? name,
    String? member,
    double? availableGoldWeight,
    String? availableGoldInCurrency,
    double? availableGoldInCurrencyVal,
    String? baseAvailableGoldInCurrency,
  }) = _QmGcaWallet;

  factory QmGcaWallet.fromJson(Map<String, dynamic> json) => _$QmGcaWalletFromJson(json);
}

@Freezed(toJson: false)
class QmGsaWallet with _$QmGsaWallet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory QmGsaWallet({
    String? name,
    String? member,
    double? holdingWeight,
    String? holdingValueInCurrency,
    double? holdingValueInCurrencyVal,
    String? baseHoldingValueInCurrency,
  }) = _QmGsaWallet;

  factory QmGsaWallet.fromJson(Map<String, dynamic> json) => _$QmGsaWalletFromJson(json);
}

class QmPayoutAccount {
  String? name;
  double? accountBalance;

  QmPayoutAccount({this.name, this.accountBalance});

  QmPayoutAccount.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accountBalance = json['account_balance'];
  }

  @override
  String toString() => 'QmPayoutAccount(name: $name, accountBalance: $accountBalance)';
}

class PayoutSettingsModel {
  String? payoutSettings;
  double? percentage;

  PayoutSettingsModel({this.payoutSettings, this.percentage});

  PayoutSettingsModel.fromJson(Map<String, dynamic> json) {
    payoutSettings = json['payout_settings'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payout_settings'] = payoutSettings;
    data['percentage'] = percentage;
    return data;
  }

  @override
  String toString() =>
      'PayoutSettingsModel(payoutSettings: $payoutSettings, percentage: $percentage)';
}
