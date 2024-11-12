import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<String> getAppVersion() async {
  final ShorebirdCodePush shorebirdCodePush = ShorebirdCodePush();
  int? patchNumber = await shorebirdCodePush.currentPatchNumber();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return "${packageInfo.version}-${patchNumber ?? 0} (${packageInfo.buildNumber})";
}
