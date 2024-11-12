import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/utils/utils.dart';
import 'faq_controller.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FAQController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "FAQ"),
          body: controller.isLoading
              ? defaultLoader()
              : ListView.builder(
                  itemCount: controller.faqs.length,
                  padding: EdgeInsets.only(top: 24, bottom: context.bottomPadding),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: getOutlineColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpandablePanel(
                        header: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              'Que. ',
                              style: TextThemeX.text14.copyWith(
                                letterSpacing: -.5,
                                color: getPrimaryColor,
                              ),
                            ),
                            Expanded(
                              child: CText(
                                controller.faqs[index].question ?? na,
                                style: TextThemeX.text14.copyWith(
                                  letterSpacing: -.5,
                                  color: getPrimaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        collapsed: Container(),
                        expanded: CText(
                          controller.faqs[index].answer ?? na,
                          softWrap: true,
                          style: TextThemeX.text12.copyWith(
                            letterSpacing: .3,
                            color: getPrimaryTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ).paddingSymmetric(vertical: 10),
                        theme: ExpandableThemeData(
                          iconSize: 14,
                          iconColor: getPrimaryTextColor,
                          expandIcon: CupertinoIcons.chevron_down,
                          collapseIcon: CupertinoIcons.chevron_up,
                          headerAlignment: ExpandablePanelHeaderAlignment.center,
                        ),
                      ),
                    );
                  },
                ).defaultHorizontal,
        );
      },
    );
  }
}
