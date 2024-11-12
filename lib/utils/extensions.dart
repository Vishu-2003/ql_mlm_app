import 'dart:math' as math;

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/utils/app_colors.dart';
import 'package:qm_mlm_flutter/utils/app_text_theme.dart';
import 'package:qm_mlm_flutter/utils/constants.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get tt => Theme.of(this).textTheme;

  ColorScheme get cs => Theme.of(this).colorScheme;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get topPadding => math.max(statusBarHeight + 15, 15);

  double get bottomPadding => math.max(bottomSafeHeight + 15, 15);

  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;

  double get bottomSafeHeight => MediaQuery.of(this).viewPadding.bottom;
}

extension WidgetExtension on Widget {
  Widget get defaultHorizontal => Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: this,
      );

  Widget prepareBottomSheet({
    required BuildContext context,
    String? title,
    Widget? trailing,
    TextEditingController? controller,
  }) {
    const Border border = Border(bottom: BorderSide(color: Color(0x4D000000), width: 0.0));
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          border: controller != null ? null : border,
          middle: CText(
            title ?? '',
            style:
                TextThemeX.text16.copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
          ),
          leading: CCoreButton(
            onPressed: () {
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: CText(
              "Close",
              style:
                  TextThemeX.text16.copyWith(color: getPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: trailing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller != null)
              Container(
                decoration: const BoxDecoration(border: border),
                child: CupertinoSearchTextField(
                  controller: controller,
                  placeholder: "Search",
                ).paddingOnly(bottom: 10, left: 10, right: 10),
              ),
            Flexible(
              child: SingleChildScrollView(
                physics: defaultScrollablePhysics,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    paddingSymmetric(horizontal: 20),
                    SizedBox(
                      height: context.bottomPadding + MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavBarButton(BuildContext context) {
    return BgBlur(
      child: Container(
        color: Colors.transparent,
        child: paddingSymmetric(horizontal: 45).paddingOnly(top: 10, bottom: context.bottomPadding),
      ),
    );
  }

  Container defaultContainer({
    double hP = 24,
    double vP = 24,
    double vM = 0,
    BoxBorder? border,
    Color? backgroundColor,
    bool showShadow = true,
    double borderRadius = 16,
    double hM = horizontalPadding,
    BoxShape shape = BoxShape.rectangle,
  }) =>
      Container(
        decoration: BoxDecoration(
          shape: shape,
          color: backgroundColor ?? getBg1,
          border: border ?? Border.all(color: getOutlineColor),
          borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: hP, vertical: vP),
        margin: EdgeInsets.symmetric(horizontal: hM, vertical: vM),
        child: this,
      );

  Widget disableWidget({bool isDisabled = false}) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: ColorFiltered(
        colorFilter: isDisabled
            ? const ColorFilter.matrix(<double>[
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ])
            : const ColorFilter.matrix(<double>[
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
        child: this,
      ),
    );
  }
}

extension StringExtension on String {
  dynamic errorSnackbar({void Function(GetSnackBar)? onTap}) {
    Get
      ..closeAllSnackbars()
      ..snackbar(
        'Error !',
        this,
        onTap: onTap,
        maxWidth: 400,
        backgroundColor: lightRed,
        colorText: getColorWhiteBlack,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      );
  }

  // yyyy-MM-dd
  DateTime get convertDefaultDateTime {
    final List<String> date = split('-');
    final int year = int.parse(date[0]);
    final int month = int.parse(date[1]);
    final int day = int.parse(date[2]);
    return DateTime(year, month, day);
  }
}

extension ResponseE7n on dio.Response {
  bool get isSuccess => statusCode! >= 200 || statusCode! < 300;
}

extension DateTimeE7n on DateTime {
  /// yyyy-MM-dd
  String get getDefaultDateFormat => DateFormat('yyyy-MM-dd').format(this);
}
