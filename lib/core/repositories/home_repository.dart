import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/providers/home_provider.dart';
import '/core/services/base_services.dart';
import '/utils/utils.dart';

class HomeRepository {
  final HomeProvider _homeProvider = Get.find<HomeProvider>();

  Future<List<GetLanguageModel>> getLanguages() async {
    try {
      return await _homeProvider.getLanguages();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getAccountTypes() async {
    try {
      return await _homeProvider.getAccountTypes();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getCurrencies() async {
    try {
      return await _homeProvider.getCurrencies();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getCountries() async {
    try {
      return await _homeProvider.getCountries();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<({PaymentMode? mode, bool attachmentRequired})>> getModeOfPayment() async {
    try {
      return await _homeProvider.getModeOfPayment();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getPayoutOptions() async {
    try {
      return await _homeProvider.getPayoutOptions();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> addMoneyWallet({
    required double amount,
    required PlatformFile file,
    required PaymentMode modeOfPayment,
  }) async {
    try {
      return await _homeProvider.addMoneyWallet(
        file: file,
        amount: amount,
        modeOfPayment: modeOfPayment,
      );
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> updatePayoutSettings({
    required List<PayoutSettingsModel>? payoutSettings,
  }) async {
    try {
      if (isNullEmptyOrFalse(payoutSettings)) throw Exception("Payout Settings is null");
      return await _homeProvider.updatePayoutSettings(payoutSettings: payoutSettings!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> registerNewMember({required PostRegisterMemberModel member}) async {
    try {
      return await _homeProvider.registerNewMember(member: member);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetDashboardModel?> getDashboardDetails() async {
    try {
      return await _homeProvider.getDashboardDetails();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetProfileModel?> getUserProfile() async {
    try {
      return await _homeProvider.getUserProfile();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetWalletModel?> getWalletDetails() async {
    try {
      return await _homeProvider.getWalletDetails();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetItemModel>> getItemList() async {
    try {
      return await _homeProvider.getItemList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetOrderModel>> getOrderList({OrdersFilterModel? filters}) async {
    try {
      return await _homeProvider.getOrderList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  Future<List<GetTransactionModel>> getTransactionList({TransactionsFilterModel? filters}) async {
    try {
      return await _homeProvider.getTransactionList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> updateProfile({required UpdateProfileModel updatedProfile}) async {
    try {
      return await _homeProvider.updateProfile(updatedProfile: updatedProfile);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> updateBankDetails({required UpdateBankModel updatedBankDetails}) async {
    try {
      return await _homeProvider.updateBankDetails(updatedBankDetails: updatedBankDetails);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> changePassword({
    required String? newPassword,
    required String? oldPassword,
  }) async {
    try {
      if (isNullEmptyOrFalse(newPassword)) throw Exception("New Password is required");
      if (isNullEmptyOrFalse(oldPassword)) throw Exception("Old Password is required");
      return await _homeProvider.changePassword(
        newPassword: newPassword!,
        oldPassword: oldPassword!,
      );
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<String>> getTicketIssueTypes() async {
    try {
      return await _homeProvider.getTicketIssueTypes();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getTicketSaverityList() async {
    try {
      return await _homeProvider.getTicketSaverityList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> createSupportTicket({
    required PostSupportTicketModel supportTicket,
  }) async {
    try {
      return await _homeProvider.createSupportTicket(supportTicket: supportTicket);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> closeAccount({
    required String reason,
  }) async {
    try {
      return await _homeProvider.closeAccount(reason: reason);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetWalletTransactionModel>> getWalletTransactions({
    WalletTransactionFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getWalletTransactions(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetWithdrawalInformationModel?> getWithdrawalInformation({double? amount}) async {
    try {
      if (isNullEmptyOrFalse(amount)) throw Exception("Amount is null");
      return await _homeProvider.getWithdrawalInformation(amount: amount!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> withdrawFund({
    required PostWithdrawFundModel withdrawFundRequest,
  }) async {
    try {
      return await _homeProvider.withdrawFund(withdrawFundRequest: withdrawFundRequest);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<({String? depositDocId, String? clientSecret, String? id})?> depositFund({
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      return await _homeProvider.depositFund(amount: amount, paymentMethod: paymentMethod);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetBuyOrderDetailsModel?> getBuyOrderDetails({
    String? item,
    double? amount,
    double? quantity,
    double? gram,
    String? itemType,
    bool? autoTrade,
    double? autoTradePrice,
  }) async {
    try {
      assert(
        gram != null || amount != null || quantity != null,
        "Gram or Amount or Quantity is required",
      );
      if (isNullEmptyOrFalse(item)) throw AppException("Item is required");
      if (isNullEmptyOrFalse(itemType)) throw AppException("Item Type is required");
      return await _homeProvider.getBuyOrderDetails(
        gram: gram,
        item: item!,
        amount: amount,
        quantity: quantity,
        itemType: itemType!,
        autoTrade: autoTrade,
        autoTradePrice: autoTradePrice,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> createOrder({required dynamic data}) async {
    try {
      if (isNullEmptyOrFalse(data)) throw AppException("Data is required");
      return await _homeProvider.createOrder(data: data!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetGoldContractModel>> getGoldContracts({required String? item}) async {
    try {
      if (isNullEmptyOrFalse(item)) throw AppException("Item is required");
      return await _homeProvider.getGoldContracts(item: item!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetSellOrderDetailsModel?> getSellOrderDetailsContract({
    required PostSellOrderDetailsContractModel? data,
  }) async {
    try {
      if (isNullEmptyOrFalse(data)) throw AppException("Data is required");
      return await _homeProvider.getSellOrderDetailsContract(data: data!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetSellOrderDetailsModel?> getSellOrderDetailsGold({
    double? gram,
    double? amount,
    bool? autoTrade,
    required String? item,
    double? autoTradePrice,
    required String? itemType,
  }) async {
    try {
      assert(gram != null || amount != null, "Gram or Amount is required");
      if (isNullEmptyOrFalse(item)) throw AppException("Item is required");
      if (isNullEmptyOrFalse(itemType)) throw AppException("Item Type is required");
      return await _homeProvider.getSellOrderDetailsGold(
        item: item!,
        gram: gram,
        amount: amount,
        itemType: itemType!,
        autoTrade: autoTrade,
        autoTradePrice: autoTradePrice,
      );
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<String>> getTransactionTypes() async {
    try {
      return await _homeProvider.getTransactionTypes();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<({String? name, String? customLocale, String? symbol})?> getCurrencyDetails() async {
    try {
      return await _homeProvider.getCurrencyDetails();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetTradeHistoryModel>> getTradeHistoryList({TradeHistoryFilterModel? filters}) async {
    try {
      return await _homeProvider.getTradeHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetTradeHistoryModel>> getMemberTradeHistoryList({
    TradeHistoryFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getMemberTradeHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetDepositHistoryModel>> getDepositHistoryList({
    DepositHistoryFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getDepositHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetWithdrawalHistoryModel>> getWithdrawalHistoryList({
    WithdrawalHistoryFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getWithdrawalHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetGSAHistoryModel>> getGSAHistoryList({GSAHistoryFilterModel? filters}) async {
    try {
      return await _homeProvider.getGSAHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel<String>?> startKYC() async {
    try {
      return await _homeProvider.startKYC();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> validateKycMobileOTP({
    required String? kycId,
    required String? mobileOtp,
  }) async {
    try {
      if (isNullEmptyOrFalse(kycId)) throw AppException("KYC Id is required");
      if (isNullEmptyOrFalse(mobileOtp)) throw AppException("Mobile OTP is required");
      return await _homeProvider.validateKycMobileOTP(kycId: kycId!, mobileOtp: mobileOtp!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> validateKycEmailOTP({
    required String? kycId,
    required String? emailOtp,
  }) async {
    try {
      if (isNullEmptyOrFalse(kycId)) throw AppException("KYC Id is required");
      if (isNullEmptyOrFalse(emailOtp)) throw AppException("Email OTP is required");
      return await _homeProvider.validateKycEmailOTP(kycId: kycId!, emailOtp: emailOtp!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> uploadKYC({required PostKYCDetailsModel kycDetails}) async {
    try {
      return await _homeProvider.uploadKYC(kycDetails: kycDetails);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetGSAConvertDetailsModel?> getGSAConvertInformation(
      {double? amount, double? gram}) async {
    try {
      return await _homeProvider.getGSAConvertInformation(amount: amount, gram: gram);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> createConvertOrder({required dynamic data}) async {
    try {
      if (isNullEmptyOrFalse(data)) throw AppException("Data is required");
      return await _homeProvider.createConvertOrder(data: data!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetTicketModel>> getTickets({TicketsFilterModel? filters}) async {
    try {
      return await _homeProvider.getTickets(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetReferralModel>> getReferrals({ReferralFilterModel? filters}) async {
    try {
      return await _homeProvider.getReferrals(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> updateProfilePhoto({required String? path}) async {
    try {
      if (isNullEmptyOrFalse(path)) throw AppException("Profile Image Path is null");
      return await _homeProvider.updateProfilePhoto(path: path!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetMemberTreeViewModel>> getMemberTreeView() async {
    try {
      return await _homeProvider.getMemberTreeView();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetMemberTreeViewModel>> getMemberChild({required String? sponser}) async {
    try {
      if (isNullEmptyOrFalse(sponser)) throw AppException("Sponser is null");
      return await _homeProvider.getMemberChild(sponser: sponser!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetNotificationModel>> getNotifications() async {
    try {
      return await _homeProvider.getNotifications();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> sendUserDeviceInfo() async {
    try {
      return await _homeProvider.sendUserDeviceInfo();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetAutoTradeOrderHistoryModel>> getAutoTradeHistoryList({
    AutoTradeOrderFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getAutoTradeHistoryList(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetCommissionModel>> getCommissionHistory({
    CommissionHistoryFilterModel? filters,
  }) async {
    try {
      return await _homeProvider.getCommissionHistory(filters: filters);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<({String? question, String? answer})>> getFAQs() async {
    try {
      return await _homeProvider.getFAQs();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<Map<String, dynamic>> getGoldRateChartDetails({
    required ChartView selectedChartView,
  }) async {
    try {
      return await _homeProvider.getGoldRateChartDetails(selectedChartView: selectedChartView);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return {};
  }

  Future<GetGoldPhysicalWithdrawalDataModel?> getGoldPhysicalWithdrawalData() async {
    try {
      return await _homeProvider.getGoldPhysicalWithdrawalData();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<String>> getGoldPhysicalWithdrawalCountryList() async {
    try {
      return await _homeProvider.getGoldPhysicalWithdrawalCountryList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getGoldPhysicalWithdrawalRegionList({required String? country}) async {
    try {
      if (isNullEmptyOrFalse(country)) throw AppException("Country is required");
      return await _homeProvider.getGoldPhysicalWithdrawalRegionList(country: country!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<GetGoldPhysicalWithdrawalBranchModel>> getGoldPhysicalWithdrawalBranchList({
    required String? region,
  }) async {
    try {
      if (isNullEmptyOrFalse(region)) throw AppException("Region is required");
      return await _homeProvider.getGoldPhysicalWithdrawalBranchList(region: region!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetGoldPhysicalWithdrawalDeliveryDetailsModel?>
      getGoldPhysicalWithdrawalDeliveryDetails() async {
    try {
      return await _homeProvider.getGoldPhysicalWithdrawalDeliveryDetails();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetGoldPhysicalWithdrawalItemModel>> getGoldPhysicalWithdrawalItems({
    required String? branch,
  }) async {
    try {
      if (isNullEmptyOrFalse(branch)) throw AppException("Branch is required");
      return await _homeProvider.getGoldPhysicalWithdrawalItems(branch: branch!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> createGoldPhysicalWithdrawalOrder({
    required PostGoldPhysicalWithdrawalOrderModel? order,
  }) async {
    try {
      if (isNullEmptyOrFalse(order)) throw AppException("Order is required");
      return await _homeProvider.createGoldPhysicalWithdrawalOrder(order: order!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> createGoldTransfer({
    required PostGoldTransferModel? data,
  }) async {
    try {
      if (isNullEmptyOrFalse(data)) throw AppException("Data is required");
      return await _homeProvider.createGoldTransfer(data: data!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetNomineeDetailsModel>> getNomineeDetails() async {
    try {
      return await _homeProvider.getNomineeDetails();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> deleteNominee({required String? nomineeId}) async {
    try {
      if (isNullEmptyOrFalse(nomineeId)) throw AppException("Nominee Id is required");
      return await _homeProvider.deleteNominee(nomineeId: nomineeId!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetMemberDetailsNomineeModel?> getMemberDetailsBeforeNomination() async {
    try {
      return await _homeProvider.getMemberDetailsBeforeNomination();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel<GetNomineeDetailsModel>?> addNominee({
    required PostAddNomineeModel? nominee,
  }) async {
    try {
      if (isNullEmptyOrFalse(nominee)) throw AppException("Nominee is required");
      return await _homeProvider.addNominee(nominee: nominee!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> verifyNomineeVerificationCode({
    required String code,
    required String email,
    required String nomineeId,
  }) async {
    try {
      return await _homeProvider.verifyNomineeVerificationCode(
        code: code,
        email: email,
        nomineeId: nomineeId,
      );
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetMerchantDetailsModel?> validateMerchantQR({required String? qrValue}) async {
    try {
      if (isNullEmptyOrFalse(qrValue)) throw AppException("QR Value is required");
      return await _homeProvider.validateMerchantQR(qrValue: qrValue!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetMerchantAvailableBalanceModel?> getMerchantAvailableBalance() async {
    try {
      return await _homeProvider.getMerchantAvailableBalance();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetMerchantGoldConvertAmountModel?> getMerchantGoldConvertAmount({
    required double? amount,
  }) async {
    try {
      if (isNullEmptyOrFalse(amount)) throw AppException("Amount is required");
      return await _homeProvider.getMerchantGoldConvertAmount(amount: amount!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> merchantGoldConvert({
    required PostMerchantGoldConvertModel? details,
  }) async {
    try {
      if (isNullEmptyOrFalse(details)) throw AppException("Details is required");
      return await _homeProvider.merchantGoldConvert(details: details!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> verifyTACCode({required String? code, required String? email}) async {
    try {
      if (isNullEmptyOrFalse(code)) throw AppException("Code is required");
      if (isNullEmptyOrFalse(email)) throw AppException("Email is required");
      return await _homeProvider.verifyTACCode(code: code!, email: email!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetGoldConvertLoanModel>> getGoldConvertOpenOrders() async {
    try {
      return await _homeProvider.getGoldConvertOpenOrders();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> goldConvertRepayment({
    required double amount,
    required List<PostGoldConvertRepaymentModel> repayments,
  }) async {
    try {
      return await _homeProvider.goldConvertRepayment(amount: amount, repayments: repayments);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetCountryCodeModel>> getCountryCodes() async {
    try {
      return await _homeProvider.getCountryCodes();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> addBeneficiary({required PostBeneficiaryModel? beneficiery}) async {
    if (beneficiery == null) throw AppException("Beneficiary is required");
    try {
      return await _homeProvider.addBeneficiary(beneficiery: beneficiery);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> updateBeneficiary({
    required UpdateBeneficiaryModel? beneficiery,
  }) async {
    if (beneficiery == null) throw AppException("Beneficiary is required");
    try {
      return await _homeProvider.updateBeneficiary(beneficiery: beneficiery);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetBeneficiaryModel>> getBeneficiaries() async {
    try {
      return await _homeProvider.getBeneficiaries();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> deleteBeneficiary({required String? beneficiaryId}) async {
    if (isNullEmptyOrFalse(beneficiaryId)) throw AppException("Beneficiary ID is required");
    try {
      return await _homeProvider.deleteBeneficiary(beneficiaryId: beneficiaryId!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetBeneficiaryModel?> getBeneficiaryById({required String? id}) async {
    if (isNullEmptyOrFalse(id)) throw AppException("Beneficiary ID is required");
    try {
      return await _homeProvider.getBeneficiaryById(id: id!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel<bool>?> markNotificationAsRead() async {
    try {
      return await _homeProvider.markNotificationAsRead();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetProfileModel?> getMemberDetails({
    required String accountNumber,
  }) async {
    try {
      return await _homeProvider.getMemberDetails(accountNumber: accountNumber);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<({Color? fontColor, Color? badgeColor})?> getBadgeDetails({
    required String badge,
  }) async {
    try {
      return await _homeProvider.getBadgeDetails(badge: badge);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<GetPhysicalGoldWithdrawalRequestModel>> getPhysicalWithdrawalRequests() async {
    try {
      return await _homeProvider.getPhysicalWithdrawalRequests();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetPhysicalGoldWithdrawalRequestModel?> getPhysicalWithdrawalOrder({
    required String id,
  }) async {
    try {
      return await _homeProvider.getPhysicalWithdrawalOrder(id: id);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetTerminateGoldConvertModel?> terminateGoldConvert({
    required String goldConvertId,
  }) async {
    try {
      return await _homeProvider.terminateGoldConvert(goldConvertId: goldConvertId);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> confirmTerminateRequest({
    required String requestId,
  }) async {
    try {
      return await _homeProvider.confirmTerminateRequest(requestId: requestId);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> cancelAutoTradeOrder({required String orderId}) async {
    try {
      return await _homeProvider.cancelAutoTradeOrder(orderId: orderId);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<String>> getIndustryTypeList() async {
    try {
      return await _homeProvider.getIndustryTypeList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getIncomeRangeList() async {
    try {
      return await _homeProvider.getIncomeRangeList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<String>> getSourceOfIncomeList() async {
    try {
      return await _homeProvider.getSourceOfIncomeList();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<GetResponseModel?> sendTransactionOtp({
    required OTPTransactionType type,
  }) async {
    try {
      return await _homeProvider.sendTransactionOtp(type: type);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> verifyTransactionOtp({
    required String code,
    required OTPTransactionType type,
  }) async {
    try {
      return await _homeProvider.verifyTransactionOtp(type: type, code: code);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
