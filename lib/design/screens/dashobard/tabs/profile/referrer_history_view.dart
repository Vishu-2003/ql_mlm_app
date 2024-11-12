import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'referrer_history_controller.dart';

class ReferrerHistoryView extends StatelessWidget {
  const ReferrerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferrerHistoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(
            title: TranslationController.td.referrerHistory,
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: () => Future.sync(() => controller.pagingController.refresh()),
            child: CPagedListView<GetReferralModel>(
              pagingController: controller.pagingController,
              itemBuilder: (BuildContext context, GetReferralModel referral, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          referral.email ?? na,
                          style: TextThemeX.text14.copyWith(color: getGrey1),
                        ),
                        CText(
                          referral.status ?? na,
                          style: TextThemeX.text16.copyWith(
                            color: getColorWhiteBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _KeyValueRow("Rank", referral.rank),
                    _KeyValueRow("Mobile", referral.mobile),
                    _KeyValueRow("Date of joining", referral.dateOfJoining),
                    _KeyValueRow("Date of birth", referral.dateOfBirth),
                    Divider(color: getOutlineColor, height: 30),
                  ],
                ).defaultHorizontal;
              },
            ),
          ),
        );
      },
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final dynamic title;
  final dynamic value;
  const _KeyValueRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CText(
            "${title ?? na} :",
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          flex: 3,
          child: CText(
            "${value ?? na}",
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
      ],
    );
  }
}
