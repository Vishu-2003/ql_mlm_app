import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class CommissionHistoryController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  DateTime? toDate;
  DateTime? fromDate;
  final int _pageSize = 20;
  final PagingController<int, GetCommissionModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage<GetCommissionModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: pagingController,
        apiCall: _homeRepository.getCommissionHistory(
          filters: CommissionHistoryFilterModel(
            start: pageKey,
            toDate: toDate,
            fromDate: fromDate,
            pageLength: _pageSize,
          ),
        ),
      );
    });
  }

  void onFromDateChanged(DateTime? date) {
    fromDate = date;
    update();
    pagingController.refresh();
  }

  void onToDateChanged(DateTime? date) {
    toDate = date;
    update();
    pagingController.refresh();
  }
}
