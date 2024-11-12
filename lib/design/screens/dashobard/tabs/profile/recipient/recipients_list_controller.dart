import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class RecipientListController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  List<GetBeneficiaryModel> recipientList = [];

  bool isLoading = false;
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    isLoading = true;
    update();
    recipientList = await _homeRepository.getBeneficiaries();
    isLoading = false;
    update();
  }

  Rx<({bool isDeleting, String beneficiaryId})> isDeletingBeneficiary =
      (isDeleting: false, beneficiaryId: "").obs;
  Future<void> deleteNominee(GetBeneficiaryModel beneficiary) async {
    await showConfirmationDialog(
      title: "Remove Recipient",
      substitle:
          "Are you sure you want to remove this Recipient (${beneficiary.beneficiaryName}) ?",
      onPositiveButtonPressed: () async {
        Get.back();
        isDeletingBeneficiary.value = (isDeleting: true, beneficiaryId: beneficiary.name!);

        GetResponseModel? response =
            await _homeRepository.deleteBeneficiary(beneficiaryId: beneficiary.name!);

        isDeletingBeneficiary.value = (isDeleting: false, beneficiaryId: beneficiary.name!);

        if (response?.isSuccess == true) {
          recipientList.remove(beneficiary);
          update();
          await showSuccessDialog(successMessage: response?.message);
        }
      },
    );
  }
}
