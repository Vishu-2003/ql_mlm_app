import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:permission_handler/permission_handler.dart';
import 'package:qm_mlm_flutter/core/models/language_model.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

String get baseUrl => kReleaseMode ? "https://qmuat.nesscale.com" : "https://qmuat.nesscale.com";

bool get isDarkMode => Get.isPlatformDarkMode;

Color get getDialogBarrierColor => getColorBlackWhite.withOpacity(.8);

// double bottomButtonHeight = 160;

const double flatButtonHeight = 50;

// double textFieldHeight = 50;

String get na => TranslationController.td.na;

const String iconPath = 'assets/icons';
const String imagePath = 'assets/images';
const String gifPath = 'assets/gifs';

const ScrollPhysics defaultScrollablePhysics = AlwaysScrollableScrollPhysics();
const ScrollPhysics neverScrollablePhysics = NeverScrollableScrollPhysics();

const double defaultButtonPressedOpacity = 0.6;

const TextOverflow defaultOverflow = TextOverflow.visible;

const double horizontalPadding = 16;

GetLanguageModel get defaultLocale => GetLanguageModel(language: 'en', languageName: 'English');

Widget defaultLoader({
  Color? color,
  double size = 50,
}) =>
    Center(child: SpinKitCircle(size: size, color: color ?? getPrimaryColor));

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || o == false || o == "";
}

void defaultSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

Widget noDataAvailableCard({String? text, double? width, double height = 100}) {
  return SizedBox(
    height: height,
    width: width ?? double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CText(
          text ?? TranslationController.td.noDataFound,
          style: TextThemeX.text16.copyWith(color: getLightGold),
        ),
      ],
    ),
  ).defaultContainer(hM: 0);
}

T? shift<T>(List<T> l) {
  if (l.isNotEmpty) {
    var first = l.first;
    l.removeAt(0);
    return first;
  }
  return null;
}

Map merge(Map? obj, Map? defaults) {
  obj ??= <dynamic, dynamic>{};
  defaults?.forEach((dynamic key, dynamic val) => obj!.putIfAbsent(key, () => val));
  return obj;
}

RegExp _ipv4Maybe = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
RegExp _ipv6 = RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

/// check if the string [str] is a URL
///
/// * [protocols] sets the list of allowed protocols
/// * [requireTld] sets if TLD is required
/// * [requireProtocol] is a `bool` that sets if protocol is required for validation
/// * [allowUnderscore] sets if underscores are allowed
/// * [hostWhitelist] sets the list of allowed hosts
/// * [hostBlacklist] sets the list of disallowed hosts
bool isURL(String? str,
    {List<String?> protocols = const ['http', 'https', 'ftp'],
    bool requireTld = true,
    bool requireProtocol = false,
    bool allowUnderscore = false,
    List<String> hostWhitelist = const [],
    List<String> hostBlacklist = const []}) {
  if (str == null || str.isEmpty || str.length > 2083 || str.startsWith('mailto:')) {
    return false;
  }
  int port;
  String? protocol, auth, user;
  String host, hostname, portStr, path, query, hash;

  // check protocol
  var split = str.split('://');
  if (split.length > 1) {
    protocol = shift(split);
    if (!protocols.contains(protocol)) {
      return false;
    }
  } else if (requireProtocol == true) {
    return false;
  }
  str = split.join('://');

  // check hash
  split = str.split('#');
  str = shift(split);
  hash = split.join('#');
  if (hash.isNotEmpty && RegExp(r'\s').hasMatch(hash)) {
    return false;
  }

  // check query params
  split = str!.split('?');
  str = shift(split);
  query = split.join('?');
  if (query.isNotEmpty && RegExp(r'\s').hasMatch(query)) {
    return false;
  }

  // check path
  split = str!.split('/');
  str = shift(split);
  path = split.join('/');
  if (path.isNotEmpty && RegExp(r'\s').hasMatch(path)) {
    return false;
  }

  // check auth type urls
  split = str!.split('@');
  if (split.length > 1) {
    auth = shift(split);
    if (auth?.contains(':') ?? false) {
      user = shift(auth!.split(':'))!;
      if (!RegExp(r'^\S+$').hasMatch(user)) {
        return false;
      }
      if (!RegExp(r'^\S*$').hasMatch(user)) {
        return false;
      }
    }
  }

  // check hostname
  hostname = split.join('@');
  split = hostname.split(':');
  host = shift(split)!;
  if (split.isNotEmpty) {
    portStr = split.join(':');
    try {
      port = int.parse(portStr, radix: 10);
    } catch (e) {
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(portStr) || port <= 0 || port > 65535) {
      return false;
    }
  }

  if (!isIP(host, null) &&
      !isFQDN(host, requireTld: requireTld, allowUnderscores: allowUnderscore) &&
      host != 'localhost') {
    return false;
  }

  if (hostWhitelist.isNotEmpty && !hostWhitelist.contains(host)) {
    return false;
  }

  if (hostBlacklist.isNotEmpty && hostBlacklist.contains(host)) {
    return false;
  }

  return true;
}

/// check if the string [str] is IP [version] 4 or 6
///
/// * [version] is a String or an `int`.
bool isIP(String? str, int? version) {
  if (version == null) {
    return isIP(str, 4) || isIP(str, 6);
  } else if (version == 4) {
    if (!_ipv4Maybe.hasMatch(str!)) {
      return false;
    }
    var parts = str.split('.');
    parts.sort((a, b) => int.parse(a) - int.parse(b));
    return int.parse(parts[3]) <= 255;
  }
  return version == 6 && _ipv6.hasMatch(str!);
}

/// check if the string [str] is a fully qualified domain name (e.g. domain.com).
///
/// * [requireTld] sets if TLD is required
/// * [allowUnderscore] sets if underscores are allowed
bool isFQDN(String str, {bool requireTld = true, bool allowUnderscores = false}) {
  var parts = str.split('.');
  if (requireTld) {
    var tld = parts.removeLast();
    if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
      return false;
    }
  }

  for (var part in parts) {
    if (allowUnderscores) {
      if (part.contains('__')) {
        return false;
      }
    }
    if (!RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
      return false;
    }
    if (part[0] == '-' || part[part.length - 1] == '-' || part.contains('---')) {
      return false;
    }
  }
  return true;
}

String attachUnit(dynamic value) {
  return "${value ?? na}${TranslationController.td.g}";
}

String getHtml(String? text) {
  if (isNullEmptyOrFalse(text?.trim())) return '';
  // Split the userInput string into separate lines
  List<String> lines = text!.split('\n');

  // Remove leading and trailing whitespace from each line
  List<String> trimmedLines = lines.map((line) => line.trim()).toList();

  // Wrap each line with <p></p> tags and remove any empty lines
  List<String> wrappedLines =
      trimmedLines.where((line) => line.isNotEmpty).map((line) => '<p>$line</p>').toList();

  // Combine the wrapped lines into a single string
  String wrappedText = wrappedLines.join('');

  return '<div class="ql-editor read-mode">$wrappedText</div>';
}

String extractTextFromHtml(html_dom.Document document) {
  // Select all paragraph elements within the specified div
  final paragraphElements =
      document.querySelector('.ql-editor.read-mode')?.getElementsByTagName('p');

  // Initialize an empty string to store the extracted text
  String extractedText = '';

  // Iterate through paragraph elements and extract their text
  for (var paragraph in paragraphElements ?? []) {
    extractedText += paragraph.text.trim() + '\n';
  }

  return extractedText;
}

Future<PermissionStatus> requestCameraPermission() async {
  return await Permission.camera.onDeniedCallback(() {
    openAppSettings();
  }).onPermanentlyDeniedCallback(() {
    openAppSettings();
  }).request();
}

String formatMobileNumber(String? countryCode, String? number) {
  if (isNullEmptyOrFalse(number)) throw 'Number cannot be null or empty';
  if (isNullEmptyOrFalse(countryCode)) throw 'Country code cannot be null or empty';
  return "$countryCode${number?.trim()}";
}
