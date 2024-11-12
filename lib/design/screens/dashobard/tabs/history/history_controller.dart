import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qm_mlm_flutter/core/models/models.dart';
import 'package:qm_mlm_flutter/core/services/gs_services.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

import '../../../../components/send_verify_transaction_otp.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';

class HistoryController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  DateTime? toDate;
  DateTime? fromDate;
  SelectionSheetItem? selectedMemberGaeHistory;
  HistoryType selectedHistoryType = HistoryType.gaeHistory;

  final int _pageSize = 20;

  List<GetMemberTreeViewModel> directMembers = [];

  final PagingController<int, GetTradeHistoryModel> tradeHistoryPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetTradeHistoryModel> memberTradeHistoryPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetGSAHistoryModel> gsaHistoryPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetDepositHistoryModel> depositPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetWithdrawalHistoryModel> withdrawalPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetAutoTradeOrderHistoryModel> goldAutoTradePagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, GetAutoTradeOrderHistoryModel> contractAutoTradePagingController =
      PagingController(firstPageKey: 0);

  Future<void> init() async {
    directMembers = await _homeRepository.getMemberChild(
      sponser: GSServices.getUser?.memberId,
    );
    update();
  }

  void onMemberGaeHistorySelected(SelectionSheetItem? selectedMember) {
    selectedMemberGaeHistory = selectedMember;
    update();
    reRefreshPage();
  }

  @override
  void onInit() {
    super.onInit();
    init();
    tradeHistoryPagingController.addPageRequestListener((pageKey) {
      fetchPage<GetTradeHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: tradeHistoryPagingController,
        apiCall: _homeRepository.getTradeHistoryList(
          filters: TradeHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });

    memberTradeHistoryPagingController.addPageRequestListener((pageKey) {
      fetchPage<GetTradeHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: memberTradeHistoryPagingController,
        apiCall: _homeRepository.getMemberTradeHistoryList(
          filters: TradeHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
            member: selectedMemberGaeHistory?.id,
          ),
        ),
      );
    });

    gsaHistoryPagingController.addPageRequestListener((pageKey) {
      fetchPage<GetGSAHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: gsaHistoryPagingController,
        apiCall: _homeRepository.getGSAHistoryList(
          filters: GSAHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });

    depositPagingController.addPageRequestListener((pageKey) {
      fetchPage<GetDepositHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: depositPagingController,
        apiCall: _homeRepository.getDepositHistoryList(
          filters: DepositHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });

    withdrawalPagingController.addPageRequestListener((pageKey) {
      fetchPage<GetWithdrawalHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: withdrawalPagingController,
        apiCall: _homeRepository.getWithdrawalHistoryList(
          filters: WithdrawalHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });

    goldAutoTradePagingController.addPageRequestListener((pageKey) {
      fetchPage<GetAutoTradeOrderHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: goldAutoTradePagingController,
        apiCall: _homeRepository.getAutoTradeHistoryList(
          filters: AutoTradeOrderFilterModel(
            start: pageKey,
            toDate: toDate,
            itemType: "Gold",
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });

    contractAutoTradePagingController.addPageRequestListener((pageKey) {
      fetchPage<GetAutoTradeOrderHistoryModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: contractAutoTradePagingController,
        apiCall: _homeRepository.getAutoTradeHistoryList(
          filters: AutoTradeOrderFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            itemType: "Contract",
            pageLength: _pageSize,
          ),
        ),
      );
    });
  }

  void onFromDateChanged(DateTime? date) {
    fromDate = date;
  }

  void onToDateChanged(DateTime? date) {
    toDate = date;
  }

  void onFilterApplied() {
    if (fromDate == null || toDate == null) {
      "Please select date range".errorSnackbar();
      return;
    }
    reRefreshPage();
  }

  void onFilterReset() {
    fromDate = null;
    toDate = null;
    reRefreshPage();
    update();
    FocusScope.of(Get.context!).unfocus();
  }

  Future<void> onHistoryTypeSelected(HistoryType selectedFilter) async {
    selectedHistoryType = selectedFilter;
    reRefreshPage();
    update();
  }

  void reRefreshPage({HistoryType? type}) {
    selectedHistoryType = type ?? selectedHistoryType;
    update();
    return switch (selectedHistoryType) {
      HistoryType.gaeHistory => tradeHistoryPagingController.refresh(),
      HistoryType.memberGaeHistory => memberTradeHistoryPagingController.refresh(),
      HistoryType.gsaHistory => gsaHistoryPagingController.refresh(),
      HistoryType.withdrawalHistory => withdrawalPagingController.refresh(),
      HistoryType.depositHistory => depositPagingController.refresh(),
      HistoryType.qmGoldAutoTradeHistory => goldAutoTradePagingController.refresh(),
      HistoryType.gaexAutoTradeHistory => contractAutoTradePagingController.refresh(),
    };
  }

  Future<void> cancelAutoTradeOrder(
      {required String orderId, required OTPTransactionType transactionType}) async {
    if (isNullEmptyOrFalse(orderId)) {
      return;
    }

    await showConfirmationDialog(
      title: "Cancel Order",
      substitle: "Are you sure you want to cancel this order?",
      onPositiveButtonPressed: () async {
        Get.back();

        final bool? isOTPVerified =
            await sendVerifyTransactionOtp(transactionType: transactionType);

        if (isOTPVerified == true) {
          Get.context?.loaderOverlay.show();
          final GetResponseModel? response =
              await _homeRepository.cancelAutoTradeOrder(orderId: orderId);
          Get.context?.loaderOverlay.hide();

          if (response?.isSuccess == true) {
            reRefreshPage();
            showSuccessDialog(successMessage: response?.message);
          }
        }
      },
    );
  }
}
