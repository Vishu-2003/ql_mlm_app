// ignore_for_file: constant_identifier_names, non_constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const UNKNOW_404 = _Paths.UNKNOWN_404;

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static OTP({required String mobileNumber}) => '${_Paths.OTP}?mobile_number=$mobileNumber';
  static const FORGOT_PASSWORD_1 = _Paths.FORGOT_PASSWORD_1;
  static const FORGOT_PASSWORD_2 = _Paths.FORGOT_PASSWORD_2;
  static const FORGOT_PASSWORD_3 = _Paths.FORGOT_PASSWORD_3;
  static SIGNUP({String? referrer}) =>
      _Paths.REGISTER_MEMBER + (referrer != null ? '?referrer=$referrer' : '');

  static const DASHBOARD = _Paths.DASHBOARD;
  static REGISTER_MEMBER({String? referrer}) =>
      _Paths.DASHBOARD + _Paths.REGISTER_MEMBER + (referrer != null ? '?referrer=$referrer' : '');
  static const KYC = _Paths.KYC;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const NETWORK = _Paths.NETWORK;
  static const SCAN_QR = _Paths.SCAN_QR;
  static const MERHCANT_PAYMENT = SCAN_QR + _Paths.MERHCANT_PAYMENT;
  static const BUY_GOLD = DASHBOARD + _Paths.BUY_GOLD;
  static const ITEM_DETAILS = DASHBOARD + _Paths.ITEM_DETAILS;
  static const SELECT_TRADE = DASHBOARD + _Paths.SELECT_TRADE;
  static const SELL_GOLD = DASHBOARD + _Paths.SELL_GOLD;
  static const _PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _PROFILE + _Paths.EDIT;
  static const CHANGE_PASSWORD = _PROFILE + _Paths.CHANGE_PASSWORD;
  static const BANK_DETAILS = _PROFILE + _Paths.BANK_DETAILS;
  static const EDIT_BANK_DETAILS = BANK_DETAILS + _Paths.EDIT;
  static WALLET_HISTORY({WalletHistoryType? type}) =>
      _PROFILE + _Paths.WALLET_HISTORY + (type != null ? '?type=${type.value}' : '');
  static const COMMISSION_HISTORY = _PROFILE + _Paths.COMMISSION_HISTORY;
  static const REFERRER_HISTORY = _PROFILE + _Paths.REFERRER_HISTORY;
  static const TICKETS = _PROFILE + _Paths.TICKETS;
  static const CREATE_TICKET = TICKETS + _Paths.CREATE_TICKET;
  static const FAQ = _PROFILE + _Paths.FAQ;
  static const GOLD_PHYSICAL_WITHDRAWAL = DASHBOARD + _Paths.GOLD_PHYSICAL_WITHDRAWAL;
  static const GOLD_TRANSFER = DASHBOARD + _Paths.GOLD_TRANSFER;
  static DEPOSIT_FUND({double amount = 0}) => '$DASHBOARD${_Paths.DEPOSIT_FUND}?amount=$amount';
  static const CONVERT_GOLD = DASHBOARD + _Paths.CONVERT_GOLD;
  static const CONVERT_GOLD_REPAYMENT = DASHBOARD + _Paths.CONVERT_GOLD_REPAYMENT;
  static const WITHDRAW_FUND = DASHBOARD + _Paths.WITHDRAW_FUND;
  static const WITHDRAW_FUND_REVIEW = WITHDRAW_FUND + _Paths.REVIEW;
  static const BENEFICIARY_DESIGNATION = _PROFILE + _Paths.BENEFICIARY_DESIGNATION;
  static const NOMINATION_DETAILS = BENEFICIARY_DESIGNATION + _Paths.NOMINATION_DETAILS;
  static get MAKE_NOMINATION_1 => BENEFICIARY_DESIGNATION + _Paths.MAKE_NOMINATION(1);
  static get MAKE_NOMINATION_2 => BENEFICIARY_DESIGNATION + _Paths.MAKE_NOMINATION(2);
  static const ADD_NOMINEE = BENEFICIARY_DESIGNATION + _Paths.ADD_NOMINEE;
  static const RECIPIENT = _PROFILE + _Paths.RECIPIENT;
  static const CREATE_RECIPIENT = RECIPIENT + _Paths.ADD;
  static const GOLD_WITHDRAWAL_REQUESTS = _PROFILE + _Paths.GOLD_WITHDRAWAL_REQUESTS;
  static GOLD_WITHDRAWAL_REQUEST_DETAILS({required String id}) =>
      "$GOLD_WITHDRAWAL_REQUESTS${_Paths.GOLD_WITHDRAWAL_REQUEST_DETAILS}?id=$id";
}

abstract class _Paths {
  static const UNKNOWN_404 = '/404';

  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const OTP = '/otp';
  static const FORGOT_PASSWORD_1 = '/forgot-password/1';
  static const FORGOT_PASSWORD_2 = '/forgot-password/2';
  static const FORGOT_PASSWORD_3 = '/forgot-password/3';
  static const REGISTER_MEMBER = '/register-member';

  static const DASHBOARD = '/dashboard';
  static const KYC = '/kyc';
  static const NOTIFICATIONS = '/notifications';
  static const NETWORK = '/network';
  static const SCAN_QR = '/scan-qr';
  static const MERHCANT_PAYMENT = '/merchant-payment';
  static const BUY_GOLD = '/buy-gold';
  static const ITEM_DETAILS = '/item-details';
  static const SELECT_TRADE = '/select-trade';
  static const SELL_GOLD = '/sell-gold';
  static const PROFILE = '/profile';
  static const ADD = '/add';
  static const EDIT = '/edit';
  static const CHANGE_PASSWORD = '/change-password';
  static const BANK_DETAILS = '/bank-details';
  static const WALLET_HISTORY = '/wallet-history';
  static const COMMISSION_HISTORY = '/commission-history';
  static const REFERRER_HISTORY = '/referrer-history';
  static const TICKETS = '/tickets';
  static const CREATE_TICKET = '/create-ticket';
  static const FAQ = '/faq';
  static const GOLD_PHYSICAL_WITHDRAWAL = '/gold-physical-withdrawal';
  static const GOLD_TRANSFER = '/gold-transfer';
  static const DEPOSIT_FUND = '/deposit-fund';
  static const WITHDRAW_FUND = '/withdraw-fund';
  static const CONVERT_GOLD = '/convert-gold';
  static const CONVERT_GOLD_REPAYMENT = '/convert-gold-repayment';
  static const REVIEW = '/review';
  static const BENEFICIARY_DESIGNATION = '/beneficiary-designation';
  static const NOMINATION_DETAILS = '/nomination-details';
  static String MAKE_NOMINATION(int step) => '/make-nomination-$step';
  static const ADD_NOMINEE = '/add-nominee';
  static const RECIPIENT = '/recipient';
  static const GOLD_WITHDRAWAL_REQUESTS = '/gold-withdrawal-requests';
  static const GOLD_WITHDRAWAL_REQUEST_DETAILS = '/gold-withdrawal-request-details';
}
