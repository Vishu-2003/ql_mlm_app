import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/notifications_controller.dart';
import '/utils/utils.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: 'Notifications'),
          body: controller.isLoading
              ? defaultLoader()
              : controller.notificationsList.isEmpty
                  ? Center(
                      child: CText(
                        "No Data Found !",
                        style: TextThemeX.text18.copyWith(
                          color: getColorWhiteBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: controller.notificationsList.length,
                      padding: EdgeInsets.only(top: 16, bottom: context.bottomPadding),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(color: getBg1, shape: BoxShape.circle),
                                child: Badge(
                                  smallSize: switch (
                                      controller.notificationsList[index].notificationRead) {
                                    false => 7,
                                    _ => 0
                                  },
                                  backgroundColor: lightRed,
                                  alignment: const Alignment(2, -2),
                                  child: selectIcon(AppIcons.bell2),
                                )),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(
                                    controller.notificationsList[index].subject ?? na,
                                    style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                                  ),
                                  CText(
                                    controller.notificationsList[index].message ?? na,
                                    overflow: TextOverflow.visible,
                                    style: TextThemeX.text16.copyWith(color: grey1),
                                  ),
                                  CText(
                                    controller.notificationsList[index].time ?? na,
                                    overflow: TextOverflow.visible,
                                    style: TextThemeX.text12.copyWith(color: getPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 24);
                      },
                    ).defaultHorizontal,
        );
      },
    );
  }
}
