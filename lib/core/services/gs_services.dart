import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/models/models.dart';
import '/utils/utils.dart';

class GSServices {
  GSServices._();
  static final GSServices _instance = GSServices._();
  factory GSServices() => _instance;

  static final GetStorage _appGS = GetStorage('app');
  static final GetStorage _userGS = GetStorage('user');
  static final GetStorage _localeGS = GetStorage('locale');

  static Future<void> initialize() async {
    await GetStorage.init('app');
    await GetStorage.init('user');
    await GetStorage.init('locale');
    await _appGS.writeIfNull('isPromptedToEnableBiometric', false);
    await _appGS.writeIfNull('bioMetricAuth', false);
    await _localeGS.writeIfNull(
      'locale',
      GetLanguageModel.defaultLocale().toJson(), ;.   1=\ );


  //! _userGS
  static Future<void> setUser({required GetLoginModel user}) async {
    await _userGS.write('user', user.toJson());
    log("<--- Local User Updated => ${getUser.toString()} --->");
  }

  static GetLoginModel? get getUser => isNullEmptyOrFalse(_userGS.read('user'))
      ? null
      : GetLoginModel.fromJson(_userGS.read('user'));

  //! _appGS -> Bio Metric
  static Future<void> setBiometricAuth({required bool? isEnabled}) async {
    await _appGS.write('bioMetricAuth', isEnabled);
    log("<--- Local BioMetric Updated => ${getBiometricAuth.toString()} --->");
  }

  static bool get getBiometricAuth => _appGS.read<bool?>('bioMetricAuth') ?? false;

  // _appGS -> is Prompted To Enable Biometric
  static Future<void> setIsPromptedToEnableBiometric({required bool? isPrompted}) async {
    await _appGS.write('isPromptedToEnableBiometric', isPrompted);
    log("<--- Local Is Prompted To Enable Biometric Updated => ${getIsPromptedToEnableBiometric.toString()} --->");
  }

  static bool get getIsPromptedToEnableBiometric =>
      _appGS.read<bool?>('isPromptedToEnableBiometric') ?? false;

  //! _localeGS
  static GetLanguageModel? get getLocale => isNullEmptyOrFalse(_localeGS.read('locale'))
      ? null
      : GetLanguageModel.fromJson(_localeGS.read('locale'));

  static Future<void> setLocale(GetLanguageModel lan) async {
    await _localeGS.write('locale', lan.toJson());
    await Get.updateLocale(Locale.fromSubtags(languageCode: lan.language));
    log("<--- Local Locale Updated => ${getLocale.toString()} --->");
  }

  static Future<void> clearLocalStorage() async {
    await _userGS.erase();
  }
}
