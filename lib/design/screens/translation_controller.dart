import 'package:get/get.dart';

import '/core/models/models.dart';

class TranslationController extends GetxController {
  static TranslationController get to => Get.find<TranslationController>();

  // final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final Rx<GetTranslationModel> _translation = GetTranslationModel().obs;

  GetTranslationDataModel get _translationData =>
      _translation.value.translationData ?? GetTranslationDataModel();

  static GetTranslationDataModel get td => TranslationController.to._translationData;

  // Future<void> getTranslation({required String? languageCode}) async {
  //   GetTranslationModel? response = await _homeRepository.getTranslationsData(
  //     languageCode: languageCode ?? defaultLocale,
  //   );
  //   if (response != null) _translation.value = response;
  //   update();
  //   Get.forceAppUpdate();
  // }
}
