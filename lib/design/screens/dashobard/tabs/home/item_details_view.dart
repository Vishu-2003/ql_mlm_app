import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/item_details_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailsController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          appBar: CAppBar(title: "${controller.item?.itemName}"),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: controller.isChartLoading
                            ? defaultLoader()
                            : SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                title: ChartTitle(
                                  text: "Gold Rates",
                                  textStyle: TextThemeX.text14.copyWith(color: getLightGold),
                                ),
                                primaryXAxis:
                                    const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
                                primaryYAxis: const NumericAxis(
                                  labelFormat: r'{value}',
                                  borderColor: lPrimaryColor,
                                  axisLine: AxisLine(width: 0),
                                  majorTickLines: MajorTickLines(size: 0),
                                ),
                                series: _getCustomValuesSeries(),
                                trackballBehavior: TrackballBehavior(
                                  enable: true,
                                  lineColor: lPrimaryColor,
                                  activationMode: ActivationMode.singleTap,
                                  tooltipSettings:
                                      const InteractiveTooltip(format: 'point.x : point.y'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ChartView.values
                            .map(
                              (chartView) => CFlatButton(
                                width: 60,
                                height: 30,
                                fontSize: 12,
                                borderRadius: 5,
                                bgColor: controller.selectedChartView == chartView
                                    ? lPrimaryColor
                                    : getBg1,
                                text: chartView.name.capitalizeFirst ?? na,
                                textColor: controller.selectedChartView == chartView
                                    ? white
                                    : getPrimaryColor,
                                border: Border.all(color: getPrimaryColor),
                                onPressed: () => controller.getChartView(chartView),
                              ).paddingSymmetric(horizontal: 5),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  detailsRow(
                    controller.item?.itemType == "Gold"
                        ? "${TranslationController.td.minimumPrice}:"
                        : "${TranslationController.td.unitPrice}:",
                    controller.item?.unitPrice ?? na,
                    value2: controller.item?.baseUnitPrice ?? na,
                  ),
                  const SizedBox(height: 5),
                  detailsRow(
                    "${TranslationController.td.goldRate}(${TranslationController.td.g}):",
                    controller.item?.goldPrice ?? na,
                    value2: controller.item?.baseGoldPrice ?? na,
                  ),
                  const SizedBox(height: 5),
                  detailsRow(
                    "${TranslationController.td.estimatedGold}:",
                    attachUnit(controller.item?.estimatedGold),
                  ),
                  if (!isNullEmptyOrFalse(controller.item?.itemInformation)) ...[
                    const SizedBox(height: 20),
                    Html(
                      data: """${controller.item?.itemInformation}""",
                      style: {
                        "p": Style(margin: Margins.zero),
                        "ol": Style(margin: Margins.zero),
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,reenscr
                        ),
                      },
                    ),
                  ],
                  SizedBox(height: context.topPadding + 50),
                ],
              ).defaultHorizontal,
            ),
          ),
          bottomNavigationBar: BgBlur(
            child: Row(
              children: [
                Expanded(
                  child: CFlatButton(
                    text: "Sell",
                    borderRadius: 12,
                    bgColor: lightRed,
                    isDisabled: !controller.isKycVerified,
                    onPressed: () {
                      controller.item?.itemType == "Gold"
                          ? Get.toNamed(
                              Routes.SELL_GOLD,
                              arguments: {'item': controller.item?.toJson()},
                            )
                          : Get.toNamed(
                              Routes.SELECT_TRADE,
                              arguments: {'item': controller.item?.toJson()},
                            );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CFlatButton(
                    text: "Buy",
                    bgColor: green,
                    borderRadius: 12,
                    isDisabled: !controller.isKycVerified,
                    onPressed: () {
                      Get.toNamed(Routes.BUY_GOLD, arguments: {'item': controller.item?.toJson()});
                    },
                  ),
                ),
              ],
            ).paddingOnly(
              top: 10,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: context.bottomPadding,
            ),
          ),
        );
      },
    );
  }

  Row detailsRow(String title, String value, {String? value2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CText(
            title,
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                value,
                style: TextThemeX.text14.copyWith(
                  color: getPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (value2 != null)
                CText(
                  value2,
                  style: TextThemeX.text12.copyWith(color: getColorWhiteBlack),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<LineSeries<dynamic, DateTime>> _getCustomValuesSeries() {
    return <LineSeries<dynamic, DateTime>>[
      LineSeries<dynamic, DateTime>(
        dataSource: Get.find<ItemDetailsController>().priceHistoryList.isEmpty
            ? []
            : List.generate(
                Get.find<ItemDetailsController>().priceHistoryList.length,
                (index) => {
                  'date': Get.find<ItemDetailsController>().timeList[index],
                  'value': Get.find<ItemDetailsController>().priceHistoryList[index]
                },
              ),
        color: lPrimaryColor,
        xValueMapper: (dynamic data, _) => data['date'],
        yValueMapper: (dynamic data, _) => data['value'],
      ),
    ];
  }
}
