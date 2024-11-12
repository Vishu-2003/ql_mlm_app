import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class TicketsListController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final int _pageSize = 20;
  final PagingController<int, GetTicketModel> pagingController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage<GetTicketModel>(
        pageKey: pageKey,
        pageSize: _pageSize,
        pagingController: pagingController,
        apiCall: _homeRepository.getTickets(
          filters: TicketsFilterModel(start: pageKey, pageLength: _pageSize),
        ),
      );
    });
  }
}
