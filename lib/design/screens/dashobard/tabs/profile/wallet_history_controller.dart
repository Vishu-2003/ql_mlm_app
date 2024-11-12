import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class WalletHistoryController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  DateTime? toDate;
  DateTime? fromDate;
  final TextEditingController selectedFilterType = TextEditingController();
  final List<GetWalletTransactionModel> walletTransactionList = [];
  final List<String> transactionTypes = [];

  final int _pageSize = 20;
  final PagingController<int, GetWalletTransactionModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();
    selectedFilterType.text = Get.parameters['type'] ?? "All";
    transactionTypes.add("All");
    pagingController.addPageRequestListener((pageKey) {
      fetchPage<GetWalletTransactionModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: pagingController,
        apiCall: _homeRepository.getWalletTransactions(
          filters: WalletTransactionFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
            // If "All" is selected, then pass null becuase API doesn't support "All" as a filter
            transactionType: selectedFilterType.text == "All" ? null : selectedFilterType.text,
          ),
        ),
      );
    });
    init();
  }

  Future<void> init() async {
    transactionTypes.insertAll(1, await _homeRepository.getTransactionTypes());
    update();
  }

  Future<void> onFilterTypeSelected(({String data, String item}) selectedFilter) async {
    selectedFilterType.text = selectedFilter.item;
    pagingController.refresh();
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
    Get.back();
    pagingController.refresh();
  }

  void onFilterReset() {
    fromDate = null;
    toDate = null;
    pagingController.refresh();
    update();
    FocusScope.of(Get.context!).unfocus();
  }
}
