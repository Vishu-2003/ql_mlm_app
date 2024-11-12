import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qm_mlm_flutter/utils/app_colors.dart';
import 'package:qm_mlm_flutter/utils/app_text_theme.dart';

class AppTheme {
  AppTheme._();

  // static final lightTheme = ThemeData.light().copyWith(
  //   primaryColor: lPrimaryColor,
  //   primaryColorLight: lPrimaryColor,
  //   scaffoldBackgroundColor: lbgColor,
  //   hintColor: lPrimaryColor.withOpacity(.4),
  //   iconTheme: const IconThemeData(size: 24, color: lPrimaryColor),
  //   appBarTheme: AppBarTheme(
  //     elevation: 0,
  //     toolbarHeight: 56,
  //     titleTextStyle: TextThemeX.text18.copyWith(
  //       color: getPrimaryTextColor,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     backgroundColor: bg2.withOpacity(.9),
  //   ),
  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //     backgroundColor: bg1,
  //     unselectedItemColor: darkG,
  //     selectedItemColor: lPrimaryColor,
  //     selectedLabelStyle: TextThemeX.text12.copyWith(
  //       color: lightGold,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     unselectedLabelStyle: TextThemeX.text12.copyWith(
  //       color: darkG,
  //       fontWeight: FontWeight.w600,
  //     ),
  //   ),
  //   textSelectionTheme: const TextSelectionThemeData(cursorColor: lPrimaryColor),
  //   cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
  //     primaryColor: lPrimaryColor,
  //     barBackgroundColor: lbgColor,
  //     scaffoldBackgroundColor: lbgColor,
  //     textTheme: CupertinoTextThemeData(
  //       textStyle: TextStyle(
  //         fontSize: 14,
  //         color: lPrimaryTextColor,
  //         fontFamily: getInterFontFamily,
  //       ),
  //       primaryColor: lPrimaryColor,
  //     ),
  //   ),
  //   dialogBackgroundColor: bg1,
  //   colorScheme: const ColorScheme.light(
  //     surface: bg1,
  //     onSurface: white,
  //     primary: lPrimaryColor,
  //   ),
  // );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: dPrimaryColor,
    primaryColorLight: dPrimaryColor,
    scaffoldBackgroundColor: dbgColor,
    hintColor: dPrimaryColor.withOpacity(.4),
    iconTheme: const IconThemeData(size: 24, color: dPrimaryColor),
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarHeight: 56,
      titleTextStyle: TextThemeX.text18.copyWith(
        color: getPrimaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: bg2.withOpacity(.9),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bg1,
      unselectedItemColor: darkG,
      selectedItemColor: lPrimaryColor,
      selectedLabelStyle: TextThemeX.text12.copyWith(
        color: lightGold,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextThemeX.text12.copyWith(
        color: darkG,
        fontWeight: FontWeight.w600,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: dPrimaryColor),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      primaryColor: dPrimaryColor,
      barBackgroundColor: dbgColor,
      scaffoldBackgroundColor: dbgColor,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontSize: 14,
          color: dPrimaryTextColor,
          fontFamily: getInterFontFamily,
        ),
        primaryColor: dPrimaryColor,
      ),
    ),
    dialogBackgroundColor: bg1,
    datePickerTheme: DatePickerThemeData(
      rangeSelectionBackgroundColor: getdarkGColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    colorScheme: const ColorScheme.dark(
      surface: bg1,
      onSurface: white,
      primary: dPrimaryColor,
    ),
  );
}
