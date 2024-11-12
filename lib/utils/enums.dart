import 'package:get/get.dart';

enum TransactionType { buy, sell }

enum OrderType { buy, sell }

enum ChartView { day, week, month, year }

enum LoginType { username, mobile }

enum GoldWithdrawalShippingType { selfCollection, delivery }

enum NomineeIdentificationType {
  myKad("MyKad"),
  myPR("MyPR"),
  myKAS("MyKAS"),
  birthCertificate("Birth Certificate"),
  passport("Passport");

  const NomineeIdentificationType(this.value);
  final String value;
}

enum NomineeRelationshipType {
  adoptedChild("Adopted Child"),
  youngerSibling("Younger Sibling"),
  adoptedFather("Adopted Father"),
  adoptedMother("Adopted Mother"),
  brother("Brother"),
  daughter("Daughter"),
  father("Father"),
  mother("Mother"),
  other("Other"),
  administrator("Administrator"),
  relative("Relative"),
  son("Son"),
  sister("Sister"),
  wife("Wife"),
  husband("Husband");

  const NomineeRelationshipType(this.value);
  final String value;
}

enum HistoryType {
  gaeHistory("GAE History"),
  memberGaeHistory("Member GAE History"),
  gsaHistory("GSA History"),
  withdrawalHistory("Withdrawal History"),
  depositHistory("Deposit History"),
  qmGoldAutoTradeHistory("QM Gold Auto Trade History"),
  gaexAutoTradeHistory("GAEX Auto Trade History");

  const HistoryType(this.value);
  final String value;
}

enum WalletHistoryType {
  deposit("Deposit"),
  withdrawal("Withdrawal");

  const WalletHistoryType(this.value);
  final String value;
}

enum OTPTransactionType {
  goldBuy("Gold Buy"),
  goldSell("Gold Sell"),
  gaeBuy("GAE Buy"),
  gaeSell("GAE Sell"),
  goldConvert("Gold Convert"),
  cancelGoldBuyAutoTrade("Cancel Gold Buy Auto Trade"),
  cancelGoldSellAutoTrade("Cancel Gold Sell Auto Trade"),
  cancelGAEBuyAutoTrade("Cancel GAE Buy Auto Trade"),
  cancelGAESellAutoTrade("Cancel GAE Sell Auto Trade"),
  goldConvertRepayment("Gold Convert Repayment"),
  goldTransfer("Gold Transfer");

  const OTPTransactionType(this.value);
  final String value;
}

enum PaymentMode {
  directTransfer("Direct Transfer"),
  stripe("Stripe");

  const PaymentMode(this.value);
  final String value;

  static PaymentMode? fromString(String value) {
    return PaymentMode.values.firstWhereOrNull((element) => element.value == value);
  }
}
