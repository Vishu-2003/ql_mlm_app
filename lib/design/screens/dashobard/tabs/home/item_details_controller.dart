import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/utils/utils.dart';

class ItemDetailsController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetItemModel? item;

  List<DateTime> timeList = [];
  List<double> priceHistoryList = [];
  ChartView selectedChartView = ChartView.week;

  @override
  void onInit() {
    super.onInit();
    item = GetItemModel.fromJson(Get.arguments);
    _getChartDetails(selectedChartView);
  }

  bool get isKycVerified => Get.find<HomeController>().dashboardDetails?.kycStatus == "Verified";
  bool isChartLoading = false;
  Future<void> _getChartDetails(ChartView selectedChartView) async {
    isChartLoading = true;
    update();
    Map<String, dynamic> data =
        await _homeRepository.getGoldRateChartDetails(selectedChartView: selectedChartView);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<String> timeString = List<String>.from(data['categories']);

    if (selectedChartView == ChartView.day) {
      timeList = timeString.map((String timeString) {
        return DateTime.parse('$today $timeString');
      }).toList();
    } else {
      timeList = timeString.map((String timeString) {
        return DateFormat('yyyy-MM-dd').parse(timeString);
      }).toList();
    }

    priceHistoryList.assignAll(List<double>.from(data['data']));

    isChartLoading = false;
    update();
  }

  Future<void> getChartView(ChartView selectedChartView) async {
    this.selectedChartView = selectedChartView;
    update();
    await _getChartDetails(selectedChartView);
  }
}
