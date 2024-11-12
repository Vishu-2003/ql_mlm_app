import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'make_nomination_1_controller.dart';

// TODO: i18n

class MakeNomination1View extends StatelessWidget {
  const MakeNomination1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GetBuilder<MakeNomination1Controller>(
        builder: (controller) {
          return Scaffold(
            appBar: const CAppBar(title: "Make Nomination"),
            body: SizedBox.expand(
              child: SingleChildScrollView(
                physics: defaultScrollablePhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    CText(
                      "Nominate your loved ones to receive your Gold savings upon your demise.",
                      style: TextThemeX.text16
                          .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    CText(
                      "To allow your loved ones to conveniently receive your Gold savings in cash when you pass on, you need to include your loved ones in a QM account nomination. Before you proceed, you should work out these details:",
                      style: TextThemeX.text14,
                    ),
                    const SizedBox(height: 16),
                    CText(
                      "Nominee",
                      style: TextThemeX.text16
                          .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    CText(
                      "You can appoint 1 nominee in this form. If you wish to appoint more than 1 nominee, please visit the QM Service Centre.",
                      style: TextThemeX.text14,
                    ),
                    const SizedBox(height: 16),
                    CText(
                      "Witnesses",
                      style: TextThemeX.text16
                          .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    CText(
                      "You will need to appoint one witness for a nomination. He/She must be at least 21 years old and not lack mental capacity; you and your nominees cannot witness your nomination.",
                      style: TextThemeX.text14,
                    ),
                    const SizedBox(height: 24),
                    CText(
                      "To complete the form, you will need:",
                      style: TextThemeX.text16
                          .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const _RichText("For yourself: ", "Mobile number or email address."),
                    const _RichText(
                      "For nominee: ",
                      "Full name, identification number and email address.",
                    ),
                    const _RichText(
                      "For witnesse: ",
                      "Full name, identification number, email address and mobile number",
                    ),
                    const _RichText(
                      "If your nominee or witness is a foreigner, You will need their mailing address and the above information.",
                      "",
                    ),
                    const SizedBox(height: 24),
                    const _Disclaimer(),
                    const SizedBox(height: 24),
                    CFlatButton(
                      text: "Start",
                      onPressed: () {
                        Get.offAndToNamed(Routes.MAKE_NOMINATION_2);
                      },
                      textColor: getPrimaryColor,
                      bgColor: getColorBlackWhite,
                      border: Border.all(color: getPrimaryColor),
                      isDisabled: !controller.isDisclaimerChecked,
                    ).defaultHorizontal,
                    SizedBox(height: context.bottomPadding),
                  ],
                ).defaultHorizontal,
              ),
            ),
          );
        },
      );
    });
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    TextStyle text1 = TextThemeX.text14;
    TextStyle text2 = TextThemeX.text14.copyWith(
      color: getColorWhiteBlack,
      fontWeight: FontWeight.w600,
    );

    return GetBuilder<MakeNomination1Controller>(
      builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CCoreButton(
              onPressed: controller.onDisclaimerChecked,
              child: Icon(
                controller.isDisclaimerChecked
                    ? CupertinoIcons.checkmark_square_fill
                    : CupertinoIcons.square,
                color: controller.isDisclaimerChecked ? getPrimaryColor : getGrey1,
              ).paddingOnly(right: 10),
            ),
            Expanded(
              child: CCoreButton(
                onPressed: controller.onDisclaimerChecked,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "I have read and accepted the ", style: text1),
                      TextSpan(text: "Disclaimer ", style: text2),
                      TextSpan(text: "and ", style: text1),
                      TextSpan(
                        text:
                            "additional important notes and information on the QM Nomination Scheme.",
                        style: text2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RichText extends StatelessWidget {
  final String title;
  final String value;
  const _RichText(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(CupertinoIcons.circle_fill, size: 8, color: getColorWhiteBlack)
            .paddingOnly(right: 10, top: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextThemeX.text14.copyWith(
                    color: getColorWhiteBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: value, style: TextThemeX.text16),
              ],
            ),
          ).paddingOnly(bottom: 6),
        ),
      ],
    ).paddingOnly(left: 30);
  }
}
