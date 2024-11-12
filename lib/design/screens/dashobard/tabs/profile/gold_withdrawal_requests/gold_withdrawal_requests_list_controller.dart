import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qm_mlm_flutter/core/models/gold_physical_withdrawal_model.dart';
import 'package:qm_mlm_flutter/core/repositories/home_repository.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';

class GoldWithdrawalRequestsListController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final int _pageSize = 20;
  final PagingController<int, GetPhysicalGoldWithdrawalRequestModel> pagingController =
      PagingController(firstPageKey: 0);
  List<GetPhysicalGoldWithdrawalRequestModel> goldWithdrawalRequests = [];

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage<GetPhysicalGoldWithdrawalRequestModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: pagingController,
        apiCall: _homeRepository.getPhysicalWithdrawalRequests(),
      );
    });
  }
}
