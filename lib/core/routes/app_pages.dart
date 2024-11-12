// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_request_details_controller.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_request_details_view.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_requests_list_controller.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_requests_list_view.dart';

import '../../design/screens/dashobard/tabs/profile/commission_history_view.dart';
import '../../utils/utils.dart';
import '/core/providers/auth_provider.dart';
import '/core/providers/home_provider.dart';
import '/core/repositories/auth_repository.dart';
import '/core/repositories/home_repository.dart';
import '/design/screens/dashobard/dashboard_controller.dart';
import '/design/screens/dashobard/dashboard_view.dart';
import '/design/screens/dashobard/network/network_controller.dart';
import '/design/screens/dashobard/network/network_tab.dart';
import '/design/screens/dashobard/qr_scanner/merchant_payment_controller.dart';
import '/design/screens/dashobard/qr_scanner/merchant_payment_view.dart';
import '/design/screens/dashobard/qr_scanner/scan_qr_controller.dart';
import '/design/screens/dashobard/qr_scanner/scan_qr_view.dart';
import '/design/screens/dashobard/tabs/home/buy_gold_controller.dart';
import '/design/screens/dashobard/tabs/home/buy_gold_view.dart';
import '/design/screens/dashobard/tabs/home/item_details_controller.dart';
import '/design/screens/dashobard/tabs/home/item_details_view.dart';
import '/design/screens/dashobard/tabs/home/kyc_controller.dart';
import '/design/screens/dashobard/tabs/home/kyc_view.dart';
import '/design/screens/dashobard/tabs/home/notifications_controller.dart';
import '/design/screens/dashobard/tabs/home/notifications_view.dart';
import '/design/screens/dashobard/tabs/home/register_member_controller.dart';
import '/design/screens/dashobard/tabs/home/register_member_view.dart';
import '/design/screens/dashobard/tabs/home/select_trade_controller.dart';
import '/design/screens/dashobard/tabs/home/select_trade_view.dart';
import '/design/screens/dashobard/tabs/home/sell_gold_controller.dart';
import '/design/screens/dashobard/tabs/home/sell_gold_view.dart';
import '/design/screens/dashobard/tabs/profile/bank_details_view.dart';
import '/design/screens/dashobard/tabs/profile/change_password_controller.dart';
import '/design/screens/dashobard/tabs/profile/change_password_view.dart';
import '/design/screens/dashobard/tabs/profile/commission_history_controller.dart';
import '/design/screens/dashobard/tabs/profile/create_ticket_controller.dart';
import '/design/screens/dashobard/tabs/profile/create_ticket_view.dart';
import '/design/screens/dashobard/tabs/profile/edit_bank_details_controller.dart';
import '/design/screens/dashobard/tabs/profile/edit_bank_details_view.dart';
import '/design/screens/dashobard/tabs/profile/edit_profile_controller.dart';
import '/design/screens/dashobard/tabs/profile/edit_profile_view.dart';
import '/design/screens/dashobard/tabs/profile/faq_controller.dart';
import '/design/screens/dashobard/tabs/profile/faq_view.dart';
import '/design/screens/dashobard/tabs/profile/nomination/add_nominee_controller.dart';
import '/design/screens/dashobard/tabs/profile/nomination/add_nominee_view.dart';
import '/design/screens/dashobard/tabs/profile/nomination/beneficiary_designation_controller.dart';
import '/design/screens/dashobard/tabs/profile/nomination/beneficiary_designation_view.dart';
import '/design/screens/dashobard/tabs/profile/nomination/make_nomination_1_controller.dart';
import '/design/screens/dashobard/tabs/profile/nomination/make_nomination_1_view.dart';
import '/design/screens/dashobard/tabs/profile/nomination/make_nomination_2_controller.dart';
import '/design/screens/dashobard/tabs/profile/nomination/make_nomination_2_view.dart';
import '/design/screens/dashobard/tabs/profile/nomination/nomination_details_controller.dart';
import '/design/screens/dashobard/tabs/profile/nomination/nomination_details_view.dart';
import '/design/screens/dashobard/tabs/profile/profile_view.dart';
import '/design/screens/dashobard/tabs/profile/recipient/add_recipient_controller.dart';
import '/design/screens/dashobard/tabs/profile/recipient/add_recipient_view.dart';
import '/design/screens/dashobard/tabs/profile/recipient/recipients_list_controller.dart';
import '/design/screens/dashobard/tabs/profile/recipient/recipients_list_view.dart';
import '/design/screens/dashobard/tabs/profile/referrer_history_controller.dart';
import '/design/screens/dashobard/tabs/profile/referrer_history_view.dart';
import '/design/screens/dashobard/tabs/profile/ticket_list_controller.dart';
import '/design/screens/dashobard/tabs/profile/tickets_list_view.dart';
import '/design/screens/dashobard/tabs/profile/wallet_history_controller.dart';
import '/design/screens/dashobard/tabs/profile/wallet_history_view.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/deposit_fund_controller.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/deposit_fund_view.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/withdraw_fund_controller.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/withdraw_fund_review_view.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/withdraw_fund_view.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_controller.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_repayment_controller.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_repayment_view.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_view.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_transfer_controller.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_transfer_view.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_withdrawal_controller.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_withdrawal_view.dart';
import '/design/screens/init_controller.dart';
import '/design/screens/startup/forgot_password_1_view.dart';
import '/design/screens/startup/forgot_password_3_view.dart';
import '/design/screens/startup/forgot_password_controller.dart';
import '/design/screens/startup/login_controller.dart';
import '/design/screens/startup/login_view.dart';
import '/design/screens/startup/otp_controller.dart';
import '/design/screens/startup/otp_view.dart';
import '/design/screens/startup/splash_view.dart';
import '/design/screens/translation_controller.dart';
import '/design/screens/unknown_404_view.dart';

part 'app_routes.dart';

class AppPages {
  static String? initialRoute = Routes.SPLASH;

  static final unknownRoute = GetPage(
    name: _Paths.UNKNOWN_404,
    page: () => const Unknown404View(),
  );

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OTPView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OtpController>(() => OtpController());
      }),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_1,
      page: () => const ForgotPasswordView1(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_2,
      page: () => const OTPView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OtpController>(() => OtpController());
      }),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_3,
      page: () => const ForgotPasswordView3(),
    ),
    GetPage(
      name: _Paths.REGISTER_MEMBER,
      page: () => const RegisterMemberView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RegisterMemberController>(() => RegisterMemberController());
      }),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
      children: [
        GetPage(
          name: _Paths.REGISTER_MEMBER,
          page: () => const RegisterMemberView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<RegisterMemberController>(() => RegisterMemberController());
          }),
        ),
        GetPage(
          name: _Paths.BUY_GOLD,
          page: () => const BuyGoldView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<BuyGoldController>(() => BuyGoldController());
          }),
        ),
        GetPage(
          name: _Paths.ITEM_DETAILS,
          page: () => const ItemDetailsView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ItemDetailsController>(() => ItemDetailsController());
          }),
        ),
        GetPage(
          name: _Paths.SELECT_TRADE,
          page: () => const SelectTradeView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SelectTradeController>(() => SelectTradeController());
          }),
        ),
        GetPage(
          name: _Paths.SELL_GOLD,
          page: () => const SellGoldView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SellGoldController>(() => SellGoldController());
          }),
        ),
        GetPage(
          name: _Paths.GOLD_PHYSICAL_WITHDRAWAL,
          page: () => const GoldWithdrawalView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GoldWithdrawalController>(() => GoldWithdrawalController());
          }),
        ),
        GetPage(
          name: _Paths.GOLD_TRANSFER,
          page: () => const GoldTransferView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GoldTransferController>(() => GoldTransferController());
          }),
        ),
        GetPage(
          name: _Paths.DEPOSIT_FUND,
          page: () => const DepositFundView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<DepositFundController>(() => DepositFundController());
          }),
        ),
        GetPage(
          name: _Paths.WITHDRAW_FUND,
          page: () => const WithdrawFundView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<WithdrawFundController>(() => WithdrawFundController());
          }),
          children: [
            GetPage(
              name: _Paths.REVIEW,
              page: () => const WithdrawFundDetailsView(),
            ),
          ],
        ),
        GetPage(
          name: _Paths.CONVERT_GOLD,
          page: () => const GoldConvertView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GoldConvertController>(() => GoldConvertController());
          }),
        ),
        GetPage(
          name: _Paths.CONVERT_GOLD_REPAYMENT,
          page: () => const GoldConvertRepaymentView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GoldConvertRepaymentController>(() => GoldConvertRepaymentController());
          }),
        ),
      ],
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationsController>(() => NotificationsController());
      }),
    ),
    GetPage(
      name: _Paths.NETWORK,
      page: () => const NetworkTab(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NetworkController>(() => NetworkController());
      }),
    ),
    GetPage(
      name: _Paths.SCAN_QR,
      page: () => const ScanQRView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ScanQRController>(() => ScanQRController());
      }),
      children: [
        GetPage(
          name: _Paths.MERHCANT_PAYMENT,
          page: () => const MerchantPaymentView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<MerchantPaymentController>(() => MerchantPaymentController());
          }),
        ),
      ],
    ),
    GetPage(
      name: _Paths.KYC,
      page: () => const KYCView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<KYCController>(() => KYCController());
      }),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      children: [
        GetPage(
          name: _Paths.EDIT,
          page: () => const EditProfileView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<EditProfileController>(() => EditProfileController());
          }),
        ),
        GetPage(
          name: _Paths.CHANGE_PASSWORD,
          page: () => const ChangePasswordView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
          }),
        ),
        GetPage(
          name: _Paths.BANK_DETAILS,
          page: () => const BankDetailsView(),
          children: [
            GetPage(
              name: _Paths.EDIT,
              page: () => const EditBankDetailsView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<EditBankDetailsController>(() => EditBankDetailsController());
              }),
            ),
          ],
        ),
        GetPage(
          name: _Paths.BENEFICIARY_DESIGNATION,
          page: () => const BeneficiaryDesignationView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<BeneficiaryDesignationController>(() => BeneficiaryDesignationController());
          }),
          children: [
            GetPage(
              name: _Paths.NOMINATION_DETAILS,
              page: () => const NominationDetailsView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<NominationDetailsController>(() => NominationDetailsController());
              }),
            ),
            GetPage(
              name: _Paths.MAKE_NOMINATION(1),
              page: () => const MakeNomination1View(),
              binding: BindingsBuilder(() {
                Get.lazyPut<MakeNomination1Controller>(() => MakeNomination1Controller());
              }),
            ),
            GetPage(
              name: _Paths.MAKE_NOMINATION(2),
              page: () => const MakeNomination2View(),
              binding: BindingsBuilder(() {
                Get.lazyPut<MakeNomination2Controller>(() => MakeNomination2Controller());
              }),
            ),
            GetPage(
              name: _Paths.ADD_NOMINEE,
              page: () => const AddNomineeView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<AddNomineeController>(() => AddNomineeController());
              }),
            ),
          ],
        ),
        GetPage(
          name: _Paths.WALLET_HISTORY,
          page: () => const WalletHistoryView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<WalletHistoryController>(() => WalletHistoryController());
          }),
        ),
        GetPage(
          name: _Paths.COMMISSION_HISTORY,
          page: () => const CommissionHistoryView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<CommissionHistoryController>(() => CommissionHistoryController());
          }),
        ),
        GetPage(
          name: _Paths.REFERRER_HISTORY,
          page: () => const ReferrerHistoryView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ReferrerHistoryController>(() => ReferrerHistoryController());
          }),
        ),
        GetPage(
          name: _Paths.TICKETS,
          page: () => const TicketListView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<TicketsListController>(() => TicketsListController());
          }),
          children: [
            GetPage(
              name: _Paths.CREATE_TICKET,
              page: () => const CreateTicketView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<CreateTicketController>(() => CreateTicketController());
              }),
            ),
          ],
        ),
        GetPage(
          name: _Paths.FAQ,
          page: () => const FAQView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<FAQController>(() => FAQController());
          }),
        ),
        GetPage(
          name: _Paths.RECIPIENT,
          page: () => const RecipientListView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<RecipientListController>(() => RecipientListController());
          }),
          children: [
            GetPage(
              name: _Paths.ADD,
              page: () => const AddRecipientView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<AddRecipientController>(() => AddRecipientController());
              }),
            ),
          ],
        ),
        GetPage(
          name: _Paths.GOLD_WITHDRAWAL_REQUESTS,
          page: () => const GoldWithdrawalRequestsListView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GoldWithdrawalRequestsListController>(
              () => GoldWithdrawalRequestsListController(),
            );
          }),
          children: [
            GetPage(
              name: _Paths.GOLD_WITHDRAWAL_REQUEST_DETAILS,
              page: () => const GoldWithdrawalRequestDetailsView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<GoldWithdrawalRequestDetailsController>(
                  () => GoldWithdrawalRequestDetailsController(),
                );
              }),
            ),
          ],
        ),
      ],
    ),
  ];
}

class BindingsX {
  static BindingsBuilder initialBindings() {
    return BindingsBuilder(() {
      Get.put<HomeProvider>(HomeProvider(), permanent: true);
      Get.put<HomeRepository>(HomeRepository(), permanent: true);
      Get.put<InitController>(InitController(), permanent: true);
      Get.lazyPut<AuthProvider>(() => AuthProvider(), fenix: true);
      Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
      Get.lazyPut<TranslationController>(() => TranslationController(), fenix: true);
    });
  }
}
