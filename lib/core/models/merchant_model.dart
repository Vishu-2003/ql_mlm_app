class GetMerchantDetailsModel {
  String? merchantName;
  String? merchantAddress;
  String? name;
  String? profile;

  GetMerchantDetailsModel({this.merchantName, this.merchantAddress, this.name, this.profile});

  GetMerchantDetailsModel.fromJson(Map<String, dynamic> json) {
    merchantName = json['merchant_name'];
    merchantAddress = json['merchant_address'];
    name = json['name'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchant_name'] = merchantName;
    data['merchant_address'] = merchantAddress;
    data['name'] = name;
    data['profile'] = profile;
    return data;
  }

  @override
  String toString() {
    return 'GetMerchantDetailsModel(merchantName: $merchantName, merchantAddress: $merchantAddress, name: $name, profile: $profile)';
  }
}

class GetMerchantAvailableBalanceModel {
  double? cashBalanceInCurrencyVal;
  String? cashBalanceInCurrency;
  double? gsaHoldingInCurrencyVal;
  String? gsaHoldingInCurrency;
  double? gsaHolding;
  double? gsaHoldingConvertedValue;
  String? gsaHoldingConvertedValueInCurrency;

  GetMerchantAvailableBalanceModel({
    this.cashBalanceInCurrencyVal,
    this.cashBalanceInCurrency,
    this.gsaHoldingInCurrencyVal,
    this.gsaHoldingInCurrency,
    this.gsaHolding,
    this.gsaHoldingConvertedValue,
    this.gsaHoldingConvertedValueInCurrency,
  });

  GetMerchantAvailableBalanceModel.fromJson(Map<String, dynamic> json) {
    cashBalanceInCurrencyVal = json['cash_balance_in_currency_val'];
    cashBalanceInCurrency = json['cash_balance_in_currency'];
    gsaHoldingInCurrencyVal = json['gsa_holding_in_currency_val'];
    gsaHoldingInCurrency = json['gsa_holding_in_currency'];
    gsaHolding = json['gsa_holding'];
    gsaHoldingConvertedValue = json['gsa_holding_converted_value'];
    gsaHoldingConvertedValueInCurrency = json['gsa_holding_converted_value_in_currency'];
  }

  @override
  String toString() {
    return 'GetMerchantAvailableBalanceModel(cashBalanceInCurrencyVal: $cashBalanceInCurrencyVal, cashBalanceInCurrency: $cashBalanceInCurrency, gsaHoldingInCurrencyVal: $gsaHoldingInCurrencyVal, gsaHoldingInCurrency: $gsaHoldingInCurrency, gsaHolding: $gsaHolding, gsaHoldingConvertedValue: $gsaHoldingConvertedValue, gsaHoldingConvertedValueInCurrency: $gsaHoldingConvertedValueInCurrency)';
  }
}

class GetMerchantGoldConvertAmountModel {
  double? actualAmount;
  String? actualAmountInCurrency;

  GetMerchantGoldConvertAmountModel({this.actualAmount, this.actualAmountInCurrency});

  GetMerchantGoldConvertAmountModel.fromJson(Map<String, dynamic> json) {
    actualAmount = json['actual_amount'];
    actualAmountInCurrency = json['actual_amount_in_currency'];
  }

  @override
  String toString() =>
      'GetMerchantGoldConvertAmountModel(actualAmount: $actualAmount, actualAmountInCurrency: $actualAmountInCurrency)';
}

class PostMerchantGoldConvertModel {
  String? merchant;
  double? actualAmount;
  double? goldPurchaseAmount;
  double? goldAmount;
  double? floatBalance;

  PostMerchantGoldConvertModel({
    required this.merchant,
    required this.actualAmount,
    required this.goldPurchaseAmount,
    required this.goldAmount,
    required this.floatBalance,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchant'] = merchant;
    data['actual_amount'] = actualAmount;
    data['gold_purchase_amount'] = goldPurchaseAmount;
    data['gold_amount'] = goldAmount;
    data['float_balance'] = floatBalance;
    return data;
  }

  @override
  String toString() {
    return 'PostMerchantGoldConvertModel(merchant: $merchant, actualAmount: $actualAmount, goldPurchaseAmount: $goldPurchaseAmount, goldAmount: $goldAmount, floatBalance: $floatBalance)';
  }
}
