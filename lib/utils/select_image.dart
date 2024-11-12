import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qm_mlm_flutter/core/services/gs_services.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/utils/app_assets.dart';
import 'package:qm_mlm_flutter/utils/constants.dart';

Widget noImage({
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) =>
    selectImage(AppImages.logo, height: height, width: width, fit: fit);

/// To select which Image/Icon being used in current mode
String setldImageIcon(
  String lightImageIcon, [
  String? darkImageIcon,
]) =>
    darkImageIcon != null && isDarkMode ? darkImageIcon : lightImageIcon;

Widget selectImage(
  String image, {
  double? width,
  double? height,
  void Function()? onPressed,
  BoxFit fit = BoxFit.cover,
}) {
  return CCoreButton(
    onPressed: onPressed,
    child: Image.asset(
      image,
      fit: fit,
      width: width,
      height: height,
    ),
  );
}

ImageProvider selectAssetImageProvider(String? image) {
  return image == null ? selectAssetImageProvider(AppImages.logo) : AssetImage(image);
}

ImageProvider selectFileImageProvider(String? image) {
  return image == null ? selectAssetImageProvider(AppImages.logo) : FileImage(File(image));
}

ImageProvider selectAPIImageProvider({String? imageUrl, String? defaultImage}) {
  return ((imageUrl != null && imageUrl.isEmpty) || imageUrl == null)
      ? selectAssetImageProvider(defaultImage ?? AppImages.logo)
      : CachedNetworkImageProvider(isURL(imageUrl) ? imageUrl : "$baseUrl$imageUrl");
}

Widget selectIcon(
  String icon, {
  double? width,
  Color? color,
  void Function()? onPressed,
}) {
  return CCoreButton(
    onPressed: onPressed,
    child: SvgPicture.asset(
      icon,
      width: width,
      height: width,
      colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    ),
  );
}

Widget networkImage({
  String? imageUrl,
  double? height,
  double? width,
  double borderRadius = 0,
  BoxFit fit = BoxFit.cover,
  void Function()? onPressed,
}) {
  return isNullEmptyOrFalse(imageUrl)
      ? noImage(fit: fit, width: width, height: height)
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: GestureDetector(
            onTap: onPressed,
            child: CachedNetworkImage(
              fit: fit,
              width: width,
              height: height,
              imageUrl: isURL(imageUrl ?? "") ? imageUrl! : "$baseUrl$imageUrl",
              placeholder: (context, url) => defaultLoader(),
              errorWidget: (context, url, error) => const Icon(
                CupertinoIcons.exclamationmark_circle,
                color: CupertinoColors.destructiveRed,
              ),
              httpHeaders: {
                "Authorization":
                    'token ${GSServices.getUser?.keyDetails?.apiKey}:${GSServices.getUser?.keyDetails?.apiSecret}',
              },
            ),
          ),
        );
}

Widget selectFileImage(String? image, {BoxFit fit = BoxFit.cover, double? height, double? width}) {
  return ((image != null && image.isEmpty) || image == null)
      ? noImage()
      : Image.file(File(image), fit: fit, width: width, height: height);
}
