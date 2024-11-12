import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class NominationDetailsController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  List<GetNomineeDetailsModel> nomineeDetails = [];

  bool isLoading = false;
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    isLoading = true;
    update();
    nomineeDetails = await _homeRepository.getNomineeDetails();
    isLoading = false;
    update();
  }

  Rx<({bool isDeleting, String nomieeId})> isDeletingNominee =
      (isDeleting: false, nomieeId: "").obs;
  Future<void> deleteNominee(GetNomineeDetailsModel nomiee) async {
    await showConfirmationDialog(
      title: "Remove Nominee",
      substitle: "Are you sure you want to remove this nominee (${nomiee.nomineeName}) ?",
      onPositiveButtonPressed: () async {
        Get.back();
        isDeletingNominee.value = (isDeleting: true, nomieeId: nomiee.name!);

        GetResponseModel? response = await _homeRepository.deleteNominee(nomineeId: nomiee.name);

        isDeletingNominee.value = (isDeleting: false, nomieeId: nomiee.name!);

        if (response?.isSuccess == true) {
          nomineeDetails.remove(nomiee);
          update();
          await showSuccessDialog(successMessage: response?.message);
        }
      },
    );
  }
}
