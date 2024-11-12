import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:qm_mlm_flutter/design/components/c_text.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class CCoreButton extends CupertinoButton {
  const CCoreButton({
    Key? key,
    Color? color,
    required Widget child,
    void Function()? onPressed,
    AlignmentGeometry alignment = Alignment.center,
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(
          key: key,
          minSize: 0,
          color: color,
          child: child,
          padding: padding,
          alignment: alignment,
          onPressed: onPressed,
          borderRadius: borderRadius,
          disabledColor: Colors.transparent,
          pressedOpacity: defaultButtonPressedOpacity,
        );
}

class CFlatButton extends StatelessWidget {
  final String text;
  final String? icon;
  final double? width;
  final double height;
  final Color? bgColor;
  final double? fontSize;
  final Color? iconColor;
  final Color? textColor;
  final BoxBorder? border;
  final Color? loaderColor;
  final String? sufficIcon;
  final bool isDisabled;
  final EdgeInsets padding;
  final double borderRadius;
  final void Function()? onPressed;
  const CFlatButton({
    Key? key,
    this.icon,
    this.border,
    this.bgColor,
    this.textColor,
    this.onPressed,
    this.fontSize,
    this.iconColor,
    this.sufficIcon,
    this.loaderColor,
    required this.text,
    this.borderRadius = 16,
    this.isDisabled = false,
    this.width = double.infinity,
    this.height = flatButtonHeight,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCoreButton(
      color: bgColor,
      onPressed: isDisabled ? null : onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Opacity(
        opacity: isDisabled || onPressed == null ? 0.5 : 1,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: border,
            color: bgColor ?? getPrimaryColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CText(
                text,
                textAlign: TextAlign.center,
                style: TextThemeX.text16.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? getBgColor,
                ),
              ),
              if (sufficIcon != null)
                selectIcon(setldImageIcon(sufficIcon!), color: iconColor)
                    .paddingSymmetric(horizontal: 8),
            ],
          ),
        ),
      ),
    );
  }
}
