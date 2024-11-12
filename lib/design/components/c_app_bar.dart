import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/components/c_text.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool shouldShowBackButton;
  final Widget? leading;
  final double leadingWidth;
  final List<Widget>? actions;
  final double? scrolledUnderElevation;
  final TextEditingController? searchController;

  const CAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.searchController,
    this.leadingWidth = 56,
    this.shouldShowBackButton = true,
    this.scrolledUnderElevation,
  });
t
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: .8,
      actions: actions,
      bottomOpacity: 0.4,
      leadingWidth: leadingWidth,
      leading: leading ??
          (shouldShowBackButton
              ? (navigator?.canPop() ?? false)
                  ? const CBackButton()
                  : null
              : null),
      scrolledUnderElevation: scrolledUnderElevation,
      title: CText(
        title ?? '',
        style: TextThemeX.text18.copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 55 + (searchController == null ? 0 : 45));
}

class CBackButton extends StatelessWidget {
  const CBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return selectIcon(
      Platform.isIOS ? AppIcons.arrowLeftiOS : AppIcons.arrowLeft,
      color: getColorWhiteBlack,
      onPressed: () {
        if (navigator?.canPop() ?? false) {
          Get.back();
        }
      },
    );
  }
}
