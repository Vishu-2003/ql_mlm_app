import 'package:flutter/material.dart';
import 'package:qm_mlm_flutter/utils/constants.dart';

Color setColor(Color lightModeColor, [Color? darkModeColor]) =>
    darkModeColor != null && isDarkMode ? darkModeColor : lightModeColor;

String get getInterFontFamily => 'Inter'; // Default

const white = Colors.white;
const black = Colors.black;
const blue = Color(0xff009EF7);
const gold = Color(0xffDCAB55);
const grey1 = Color(0xff9899AC);
const goldGradient1 = gold;
const goldGradient2 = Color(0xff9F7124);
const lightGold = Color(0xffF4F2EF);
const darkG = Color(0xff87877D);
const bg1 = Color(0xff0D0D0D);
const bg2 = Color(0xff101010);
const outline = Color(0xff313131);
const lightRed = Color(0xFFE55342);
const green = Color(0xFF00CF81);
const yellow = Colors.yellow;

const lPrimaryColor = gold;
const dPrimaryColor = gold;
const lbgColor = black;
const dbgColor = black;
const lPrimaryTextColor = grey1;
const dPrimaryTextColor = grey1;

Color get getBgColor => setColor(lbgColor);
Color get getPrimaryColor => setColor(lPrimaryColor);
Color get getPrimaryTextColor => setColor(lPrimaryTextColor);

Color get getColorWhiteBlack => setColor(white);
Color get getColorBlackWhite => setColor(black);
Color get getBg1 => setColor(bg1);
Color get getBg2 => setColor(bg2);
Color get getLightGold => setColor(lightGold);
Color get getOutlineColor => setColor(outline);
Color get getdarkGColor => setColor(darkG);
Color get getGrey1 => setColor(grey1);
Color get pullDownMenuBgColor => setColor(const Color(0xff282828));
