import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '/core/models/models.dart';
import '/core/services/base_services.dart';
import '/utils/utils.dart';

class HomeProvider with BaseService {
  void dispose() {}

  Future<List<GetLanguageModel>> getLanguages() async {
    return tryOrCatch<List<GetLanguageModel>>(
      () async {
        return [
          GetLanguageModel(languageName: 'English', language: 'en'),
          GetLanguageModel(languageName: 'Malay', language: 'ms'),
          GetLanguageModel(languageName: 'Chinese', language: 'zh'),
          GetLanguageModel(languageName: 'Thai', language: 'th'),
        ];
      },
    );
  }

  Future<List<String>> getAccountTypes() async {
    return tryOrCatch<List<String>>(
      () async {
        return ["Personal", "Joint", "Corporate", "Trust"];
      },
    );
  }

  Future<List<String>> getCurrencies() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_currency_list',
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<String>> getCountries() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_country_list',
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<({PaymentMode? mode, bool attachmentRequired})>> getModeOfPayment() async {
    return tryOrCatch<List<({PaymentMode? mode, bool attachmentRequired})>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_mode_of_payment',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map(
            (e) => (
              mode: PaymentMode.fromString(e['name']),
              attachmentRequired: e['attachment_requied'] == 1,
            ),
          )
          .toList();
    });
  }

  Future<List<String>> getPayoutOptions() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_payout_options',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e as String).toList();
    });
  }

  Future<GetResponseModel> addMoneyWallet({
    required double amount,
    required PlatformFile file,
    required PaymentMode modeOfPayment,
  }) async {
    FormData formData = FormData.fromMap({
      "amount": amount,
      "mode_of_payment": modeOfPayment.value,
      "file": await MultipartFile.fromFile(file.path!, filename: file.name),
    });
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.transaction.add_money_wallet',
        data: formData,
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> updatePayoutSettings({
    required List<PayoutSettingsModel> payoutSettings,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.update_payout_setting',
        data: {
          'qm_member_payout_setting': payoutSettings.map((e) => e.toJson()).toList(),
        },
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> registerNewMember({required PostRegisterMemberModel member}) async {
    FormData formData = await member.toFormData();
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.register',
        data: formData,
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetDashboardModel> getDashboardDetails() async {
    return tryOrCatch<GetDashboardModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.dashboard',
        options: Options(extra: requiresToken),
      );

      return GetDashboardModel.fromJson(response.data['data'][0]);
    });
  }

  Future<GetProfileModel> getUserProfile() async {
    return tryOrCatch<GetProfileModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.profile',
        options: Options(extra: requiresToken),
      );

      return GetProfileModel.fromJson(response.data['data']);
    });
  }

  Future<GetWalletModel> getWalletDetails() async {
    return tryOrCatch<GetWalletModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.wallet',
        options: Options(extra: requiresToken),
      );

      return GetWalletModel.fromJson(response.data['data'][0]);
    });
  }

  Future<List<GetItemModel>> getItemList() async {
    return tryOrCatch<List<GetItemModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.qm_item_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetItemModel.fromJson(e)).toList();
    });
  }

  Future<List<GetOrderModel>> getOrderList({OrdersFilterModel? filters}) async {
    return tryOrCatch<List<GetOrderModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.list',
        data: {"filters": filters?.toMap() ?? {}},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetOrderModel.fromJson(e)).toList();
    });
  }

  Future<List<GetTransactionModel>> getTransactionList({TransactionsFilterModel? filters}) async {
    return tryOrCatch<List<GetTransactionModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.qm_transaction_list',
        data: {"filters": filters?.toMap() ?? {}},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetTransactionModel.fromJson(e)).toList();
    });
  }

  Future<GetResponseModel> updateProfile({required UpdateProfileModel updatedProfile}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.update_profile',
        data: updatedProfile.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> updateBankDetails({required UpdateBankModel updatedBankDetails}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.update_profile',
        data: updatedBankDetails.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.change_password',
        data: {
          'new_password': newPassword,
          'current_password': oldPassword,
        },
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<String>> getTicketIssueTypes() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.support.ticket.get_issue_type_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<String>> getTicketSaverityList() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.support.ticket.get_saverity_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e as String).toList();
    });
  }

  Future<GetResponseModel> createSupportTicket({
    required PostSupportTicketModel supportTicket,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.support.ticket.create_ticket',
        data: supportTicket.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> closeAccount({
    required String reason,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.close_account',
        data: {'reason': reason},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetWalletTransactionModel>> getWalletTransactions({
    WalletTransactionFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetWalletTransactionModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.transaction.get_wallet_transaction',
        data: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetWalletTransactionModel.fromJson(e))
          .toList();
    });
  }

  Future<GetWithdrawalInformationModel> getWithdrawalInformation({required double amount}) async {
    return tryOrCatch<GetWithdrawalInformationModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.transaction.get_withdrawal_information',
        queryParameters: {'amount': amount},
        options: Options(extra: requiresToken),
      );

      return GetWithdrawalInformationModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> withdrawFund({
    required PostWithdrawFundModel withdrawFundRequest,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.transaction.withdraw_money_wallet',
        data: withdrawFundRequest.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  // TODO: 2 imp. of add_money_wallet, make it 1
  Future<({String? depositDocId, String? clientSecret, String? id})> depositFund({
    required double amount,
    required String paymentMethod,
  }) async {
    return tryOrCatch<({String? depositDocId, String? clientSecret, String? id})>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.transaction.add_money_wallet',
        data: {"amount": amount, "mode_of_payment": paymentMethod},
        options: Options(extra: requiresToken),
      );

      return (
        id: response.data['data']['id'] as String?,
        depositDocId: response.data['data']['deposit_doc_id'] as String?,
        clientSecret: response.data['data']['client_secret'] as String?,
      );
    });
  }

  Future<GetBuyOrderDetailsModel> getBuyOrderDetails({
    required String item,
    double? gram,
    double? amount,
    bool? autoTrade,
    double? quantity,
    double? autoTradePrice,
    required String itemType,
  }) async {
    return tryOrCatch<GetBuyOrderDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_buy_order_details',
        data: {
          "item": item,
          "item_type": itemType,
          "transaction_type": "Buy",
          if (!isNullEmptyOrFalse(quantity)) "qty": quantity,
          if (!isNullEmptyOrFalse(amount)) "amount": amount,
          if (!isNullEmptyOrFalse(gram)) "gram": gram,
          if (autoTrade == true) "auto_trade": autoTrade,
          if (autoTrade == true) "auto_trade_price": autoTradePrice
        },
        options: Options(extra: requiresToken),
      );

      return GetBuyOrderDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> createOrder({required dynamic data}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.order.create',
        data: data,
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetGoldContractModel>> getGoldContracts({required String item}) async {
    return tryOrCatch<List<GetGoldContractModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_gold_contract',
        data: {'item': item},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetGoldContractModel.fromJson(e)).toList();
    });
  }

  Future<GetSellOrderDetailsModel> getSellOrderDetailsContract({
    required PostSellOrderDetailsContractModel data,
  }) async {
    return tryOrCatch<GetSellOrderDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_sell_order_details_contract',
        data: data.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetSellOrderDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<GetSellOrderDetailsModel> getSellOrderDetailsGold({
    double? gram,
    double? amount,
    bool? autoTrade,
    required String item,
    double? autoTradePrice,
    required String itemType,
  }) async {
    return tryOrCatch<GetSellOrderDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_sell_order_details_gold',
        data: {
          "gram": gram,
          "item": item,
          "amount": amount,
          "item_type": itemType,
          if (autoTrade == true) "auto_trade": autoTrade,
          if (autoTrade == true) "auto_trade_price": autoTradePrice
        },
        options: Options(extra: requiresToken),
      );

      return GetSellOrderDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<List<String>> getTransactionTypes() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_qm_transaction_type',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<({String? name, String? customLocale, String? symbol})> getCurrencyDetails() async {
    return tryOrCatch<({String? name, String? customLocale, String? symbol})>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_currency_details',
        options: Options(extra: requiresToken),
      );

      return (
        name: response.data['data']['name'] as String?,
        customLocale: response.data['data']['custom_locale'] as String?,
        symbol: response.data['data']['symbol'] as String?
      );
    });
  }

  Future<List<GetTradeHistoryModel>> getTradeHistoryList({TradeHistoryFilterModel? filters}) async {
    return tryOrCatch<List<GetTradeHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_trade_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetTradeHistoryModel.fromJson(e)).toList();
    });
  }

  Future<List<GetTradeHistoryModel>> getMemberTradeHistoryList({
    TradeHistoryFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetTradeHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.member_get_trade_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetTradeHistoryModel.fromJson(e)).toList();
    });
  }

  Future<List<GetDepositHistoryModel>> getDepositHistoryList({
    DepositHistoryFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetDepositHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.transaction.get_deposit_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetDepositHistoryModel.fromJson(e))
          .toList();
    });
  }

  Future<List<GetWithdrawalHistoryModel>> getWithdrawalHistoryList({
    WithdrawalHistoryFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetWithdrawalHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.transaction.get_withdrawal_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetWithdrawalHistoryModel.fromJson(e))
          .toList();
    });
  }

  Future<List<GetGSAHistoryModel>> getGSAHistoryList({
    GSAHistoryFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetGSAHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_gsa_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetGSAHistoryModel.fromJson(e)).toList();
    });
  }

  Future<GetResponseModel<String>> startKYC() async {
    return tryOrCatch<GetResponseModel<String>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.kyc.start_kyc',
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response)..data = response.data['data'] as String;
    });
  }

  Future<GetResponseModel> validateKycMobileOTP({
    required String kycId,
    required String mobileOtp,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.kyc.validate_kyc_mobile_otp',
        data: {'kyc': kycId, 'mobile_otp': mobileOtp},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> validateKycEmailOTP({
    required String kycId,
    required String emailOtp,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.kyc.validate_kyc_emailotp',
        data: {'kyc': kycId, 'email_otp': emailOtp},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> uploadKYC({required PostKYCDetailsModel kycDetails}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final Map<String, dynamic> data = await kycDetails.toJson();
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.kyc.upload_kyc',
        data: data,
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetGSAConvertDetailsModel> getGSAConvertInformation({
    required double? gram,
    required double? amount,
  }) async {
    return tryOrCatch<GetGSAConvertDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_gsa_convert_details',
        queryParameters: {'amount': amount, 'gram': gram},
        options: Options(extra: requiresToken),
      );

      return GetGSAConvertDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> createConvertOrder({required dynamic data}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.order.create_convert_order',
        data: data,
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetTicketModel>> getTickets({TicketsFilterModel? filters}) async {
    return tryOrCatch<List<GetTicketModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.support.ticket.get_tickets',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetTicketModel.fromJson(e)).toList();
    });
  }

  Future<List<GetReferralModel>> getReferrals({ReferralFilterModel? filters}) async {
    return tryOrCatch<List<GetReferralModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_my_referral',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetReferralModel.fromJson(e)).toList();
    });
  }

  Future<GetResponseModel> updateProfilePhoto({required String path}) async {
    return tryOrCatch<GetResponseModel>(() async {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          path,
          filename: path.split('/').last,
        ),
      });
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.update_profile_photo',
        data: formData,
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetMemberTreeViewModel>> getMemberTreeView() async {
    return tryOrCatch<List<GetMemberTreeViewModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_member_tree_view',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetMemberTreeViewModel.fromJson(e))
          .toList();
    });
  }

  Future<List<GetMemberTreeViewModel>> getMemberChild({required String sponser}) async {
    return tryOrCatch<List<GetMemberTreeViewModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_member_child',
        queryParameters: {'sponser_name': sponser},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetMemberTreeViewModel.fromJson(e))
          .toList();
    });
  }

  Future<List<GetNotificationModel>> getNotifications() async {
    return tryOrCatch<List<GetNotificationModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_notification_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetNotificationModel.fromJson(e)).toList();
    });
  }

  Future<GetResponseModel> sendUserDeviceInfo() async {
    return tryOrCatch(() async {
      String? osVersion, deviceName;

      String appVersion = await getAppVersion();
      String? token = await FirebaseMessaging.instance.getToken();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
        osVersion = androidInfo.version.sdkInt.toString();
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine;
        osVersion = iosInfo.systemVersion;
      }

      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.user_device_info',
        data: {
          "token": token,
          "os_version": osVersion,
          "device_name": deviceName,
          "app_version": appVersion,
          "platform": Platform.operatingSystem,
        },
        options: Options(extra: requiresToken),
      );
      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetAutoTradeOrderHistoryModel>> getAutoTradeHistoryList({
    AutoTradeOrderFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetAutoTradeOrderHistoryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.order.get_auto_trade_order_list',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetAutoTradeOrderHistoryModel.fromJson(e))
          .toList();
    });
  }

  Future<List<GetCommissionModel>> getCommissionHistory({
    CommissionHistoryFilterModel? filters,
  }) async {
    return tryOrCatch<List<GetCommissionModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_commission_history',
        queryParameters: filters?.toMap(),
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetCommissionModel.fromJson(e)).toList();
    });
  }

  Future<List<({String? question, String? answer})>> getFAQs() async {
    return tryOrCatch<List<({String? question, String? answer})>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_faq_details',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => (question: e['question'] as String?, answer: e['answer'] as String?))
          .toList();
    });
  }

  Future<Map<String, dynamic>> getGoldRateChartDetails({
    required ChartView selectedChartView,
  }) async {
    return tryOrCatch<Map<String, dynamic>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_gold_rate_charts',
        options: Options(extra: requiresToken),
        data: {
          "day": selectedChartView == ChartView.day ? true : false,
          "week": selectedChartView == ChartView.week ? true : false,
          "month": selectedChartView == ChartView.month ? true : false,
          "year": selectedChartView == ChartView.year ? true : false,
        },
      );

      return response.data['data'];
    });
  }

  Future<GetGoldPhysicalWithdrawalDataModel> getGoldPhysicalWithdrawalData() async {
    return tryOrCatch<GetGoldPhysicalWithdrawalDataModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_gold_physical_withdrawal',
        options: Options(extra: requiresToken),
      );

      return GetGoldPhysicalWithdrawalDataModel.fromJson(response.data['data']);
    });
  }

  Future<List<String>> getGoldPhysicalWithdrawalCountryList() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_country_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<String>> getGoldPhysicalWithdrawalRegionList({required String country}) async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_region_list',
        queryParameters: {'country': country},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<GetGoldPhysicalWithdrawalBranchModel>> getGoldPhysicalWithdrawalBranchList({
    required String region,
  }) async {
    return tryOrCatch<List<GetGoldPhysicalWithdrawalBranchModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_branch_list',
        queryParameters: {'region': region},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetGoldPhysicalWithdrawalBranchModel.fromJson(e))
          .toList();
    });
  }

  Future<GetGoldPhysicalWithdrawalDeliveryDetailsModel>
      getGoldPhysicalWithdrawalDeliveryDetails() async {
    return tryOrCatch<GetGoldPhysicalWithdrawalDeliveryDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_delivery_details',
        options: Options(extra: requiresToken),
      );

      return GetGoldPhysicalWithdrawalDeliveryDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<List<GetGoldPhysicalWithdrawalItemModel>> getGoldPhysicalWithdrawalItems({
    required String branch,
  }) async {
    return tryOrCatch<List<GetGoldPhysicalWithdrawalItemModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_physical_withdrawal_items',
        queryParameters: {'branch': branch},
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetGoldPhysicalWithdrawalItemModel.fromJson(e))
          .toList();
    });
  }

  Future<GetResponseModel> createGoldPhysicalWithdrawalOrder({
    required PostGoldPhysicalWithdrawalOrderModel order,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.create_physical_gold_withdraw_order',
        data: order.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> createGoldTransfer({
    required PostGoldTransferModel data,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.gold_transfer.create_gold_transfer',
        data: data.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetNomineeDetailsModel>> getNomineeDetails() async {
    return tryOrCatch<List<GetNomineeDetailsModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.nominee.nominee_details',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetNomineeDetailsModel.fromJson(e))
          .toList();
    });
  }

  Future<GetResponseModel> deleteNominee({required String nomineeId}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.nominee.delete_nominee',
        data: {'nominee_id': nomineeId},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetMemberDetailsNomineeModel> getMemberDetailsBeforeNomination() async {
    return tryOrCatch<GetMemberDetailsNomineeModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.nominee.get_member_details_before_nomination',
        options: Options(extra: requiresToken),
      );

      return GetMemberDetailsNomineeModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel<GetNomineeDetailsModel>> addNominee({
    required PostAddNomineeModel nominee,
  }) async {
    return tryOrCatch<GetResponseModel<GetNomineeDetailsModel>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.nominee.add_nominee',
        data: nominee.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response)
        ..data = GetNomineeDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> verifyNomineeVerificationCode({
    required String code,
    required String email,
    required String nomineeId,
  }) async {
    return tryOrCatch<GetResponseModel<GetNomineeDetailsModel>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.verify_nominee_verification_code',
        data: {"code": code, "email": email, "nominee_id": nomineeId},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetMerchantDetailsModel> validateMerchantQR({required String qrValue}) async {
    return tryOrCatch<GetMerchantDetailsModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.merchant.validate_qr_code',
        data: {'qr_value': qrValue},
        options: Options(extra: requiresToken),
      );

      return GetMerchantDetailsModel.fromJson(response.data['data']);
    });
  }

  Future<GetMerchantAvailableBalanceModel> getMerchantAvailableBalance() async {
    return tryOrCatch<GetMerchantAvailableBalanceModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.merchant.get_available_balance',
        options: Options(extra: requiresToken),
      );

      return GetMerchantAvailableBalanceModel.fromJson(response.data['data']);
    });
  }

  Future<GetMerchantGoldConvertAmountModel> getMerchantGoldConvertAmount({
    required double amount,
  }) async {
    return tryOrCatch<GetMerchantGoldConvertAmountModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.merchant.get_immediate_gold_convert_amount',
        data: {'amount': amount},
        options: Options(extra: requiresToken),
      );

      return GetMerchantGoldConvertAmountModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> merchantGoldConvert({
    required PostMerchantGoldConvertModel details,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.merchant.immediate_gold_convert',
        data: details.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> verifyTACCode({required String code, required String email}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.verify_tac_verification_code',
        data: {"code": code, "email": email},
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetGoldConvertLoanModel>> getGoldConvertOpenOrders() async {
    return tryOrCatch<List<GetGoldConvertLoanModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_convert_repayment.get_gold_convert_open_order',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetGoldConvertLoanModel.fromJson(e))
          .toList();
    });
  }

  Future<GetResponseModel> goldConvertRepayment({
    required double amount,
    required List<PostGoldConvertRepaymentModel> repayments,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.gold_convert_repayment.create_gold_convert_repayment',
        options: Options(extra: requiresToken),
        data: {
          "paid_amount": amount,
          "gold_convert_repayment_details": repayments.map((e) => e.toJson()).toList(),
        },
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetCountryCodeModel>> getCountryCodes() async {
    return tryOrCatch<List<GetCountryCodeModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.general_api.get_country_code',
      );

      return (response.data['data'] as List).map((e) => GetCountryCodeModel.fromJson(e)).toList();
    });
  }

  Future<GetResponseModel> addBeneficiary({required PostBeneficiaryModel beneficiery}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.add_beneficiary',
        data: beneficiery.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> updateBeneficiary({required UpdateBeneficiaryModel beneficiery}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.edit_beneficiary',
        data: beneficiery.toJson(),
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<GetBeneficiaryModel>> getBeneficiaries() async {
    return tryOrCatch<List<GetBeneficiaryModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.beneficiary_list',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => GetBeneficiaryModel.fromJson(e)).toList();
    });
  }

  Future<GetBeneficiaryModel> getBeneficiaryById({required String id}) async {
    return tryOrCatch<GetBeneficiaryModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.beneficiary_details',
        queryParameters: {'beneficiary_id': id},
        options: Options(extra: requiresToken),
      );

      return GetBeneficiaryModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> deleteBeneficiary({required String beneficiaryId}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.delete_beneficiary',
        queryParameters: {'beneficiary_id': beneficiaryId},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel<bool>> markNotificationAsRead() async {
    return tryOrCatch<GetResponseModel<bool>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.update_notification_as_read',
        options: Options(extra: requiresToken),
      );
      return GetResponseModel.fromResponse(response)..data = true;
    });
  }

  Future<GetProfileModel> getMemberDetails({
    required String accountNumber,
  }) async {
    return tryOrCatch<GetProfileModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.beneficiary.get_member_details',
        data: {'account_number': accountNumber},
        options: Options(extra: requiresToken),
      );
      return GetProfileModel.fromJson(response.data['data']);
    });
  }

  Future<({Color? fontColor, Color? badgeColor})> getBadgeDetails({
    required String badge,
  }) async {
    return tryOrCatch<({Color fontColor, Color badgeColor})>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_badge_details',
        data: {'badge': badge},
        options: Options(extra: requiresToken),
      );
      return (
        fontColor: Color(int.parse(response.data['data']['font_color']?.replaceAll('#', '0xff'))),
        badgeColor: Color(int.parse(response.data['data']['badge_color']?.replaceAll('#', '0xff'))),
      );
    });
  }

  Future<List<GetPhysicalGoldWithdrawalRequestModel>> getPhysicalWithdrawalRequests() async {
    return tryOrCatch<List<GetPhysicalGoldWithdrawalRequestModel>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_physical_withdrawal_requests',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List)
          .map((e) => GetPhysicalGoldWithdrawalRequestModel.fromJson(e))
          .toList();
    });
  }

  Future<GetPhysicalGoldWithdrawalRequestModel> getPhysicalWithdrawalOrder({
    required String id,
  }) async {
    return tryOrCatch<GetPhysicalGoldWithdrawalRequestModel>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.gold_withdrawal.get_physical_withdrawal_order',
        queryParameters: {'name': id},
        options: Options(extra: requiresToken),
      );

      return GetPhysicalGoldWithdrawalRequestModel.fromJson(response.data['data']);
    });
  }

  Future<GetTerminateGoldConvertModel> terminateGoldConvert({
    required String goldConvertId,
  }) async {
    return tryOrCatch<GetTerminateGoldConvertModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.gold_convert_repayment.terminate_gold_convert',
        data: {'gold_convert_id': goldConvertId},
        options: Options(extra: requiresToken),
      );

      return GetTerminateGoldConvertModel.fromJson(response.data['data']);
    });
  }

  Future<GetResponseModel> confirmTerminateRequest({
    required String requestId,
  }) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.gold_convert_repayment.confirm_terminate_request',
        data: {'request_id': requestId},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> cancelAutoTradeOrder({required String orderId}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.order.cancel_auto_trade_order',
        data: {'order_id': orderId},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<List<String>> getIndustryTypeList() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_industry_type',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<String>> getIncomeRangeList() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_income_range',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<List<String>> getSourceOfIncomeList() async {
    return tryOrCatch<List<String>>(() async {
      final response = await dio.get(
        '/api/method/qm_trading.mobile$apiVersion.user.get_source_of_income',
        options: Options(extra: requiresToken),
      );

      return (response.data['data'] as List).map((e) => e['name'] as String).toList();
    });
  }

  Future<GetResponseModel> sendTransactionOtp({
    required OTPTransactionType type,
  }) async {
    return tryOrCatch<GetResponseModel<GetNomineeDetailsModel>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.send_transaction_otp',
        data: {"transaction_type": type.value},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetResponseModel> verifyTransactionOtp({
    required String code,
    required OTPTransactionType type,
  }) async {
    return tryOrCatch<GetResponseModel<GetNomineeDetailsModel>>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.verify_otp',
        data: {"transaction_type": type.value, "code": code},
        options: Options(extra: requiresToken),
      );

      return GetResponseModel.fromResponse(response);
    });
  }
}
