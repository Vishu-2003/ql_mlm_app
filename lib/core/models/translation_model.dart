import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_model.freezed.dart';
part 'translation_model.g.dart';

@Freezed(toJson: false)
class GetTranslationModel with _$GetTranslationModel {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetTranslationModel({
    String? direction,
    GetTranslationDataModel? translationData,
  }) = _GetTranslationModel;

  factory GetTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$GetTranslationModelFromJson(json);
}

@Freezed(toJson: false)
class GetTranslationDataModel with _$GetTranslationDataModel {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetTranslationDataModel({
    @Default('Home') String home,
    @Default('Wallet') String wallet,
    @Default('History') String history,
    @Default('My Network') String myNetwork,
    @Default('Network') String network,
    @Default('Total Introducers') String totalIntroducers,
    @Default('Personal Trade') String personalTrade,
    @Default('Member Trade') String memberTrade,
    @Default('Total Commissions') String totalCommissions,
    @Default('Balance') String balance,
    @Default('Units') String units,
    @Default('Unit Price') String unitPrice,
    @Default('Gold Rate') String goldRate,
    @Default('Estimated Gold') String estimatedGold,
    @Default('Buy Gold') String buyGold,
    @Default('Sell Gold') String sellGold,
    @Default('gm') String g,
    @Default('Gold Storage Account') String goldStorageAccount,
    @Default('gsa') String gsa,
    @Default('Metal Holding In Weight') String metalHoldingInWeight,
    @Default('Current Value in Currency') String currentValueInCurrency,
    @Default('Base on Gold Spot Price') String baseOnGoldSpotPrice,
    @Default('Available Gold Convert Account') String availableGoldConvertAccount,
    @Default('gca') String gca,
    @Default('Available Gold Convert in Weight') String availableGoldConvertInWeight,
    @Default('oz/g') String ozg,
    @Default('Available Gold Convert Value in Currency') String availableGoldConvertValueInCurrency,
    @Default('Float Account') String floatAccount,
    @Default('Cash Balance in Currency') String cashBalanceInCurrency,
    @Default('Deposit') String deposit,
    @Default('Withdrawal') String withdrawal,
    @Default('Payout Account') String payoutAccount,
    @Default('Payout Account Balance') String payoutAccountBalance,
    @Default('Total') String total,
    @Default('Paid') String paid,
    @Default('Buy') String buy,
    @Default('Sell') String sell,
    @Default('View Details') String viewDetails,
    @Default('Profile') String profile,
    @Default('Edit Profile') String editProfile,
    @Default('Currency') String currency,
    @Default('Account Type') String accountType,
    @Default('Sponsor') String sponsor,
    @Default('Username') String userName,
    @Default('Date of Birth') String dateOfBirth,
    @Default('Address') String address,
    @Default('Change Password') String changePassword,
    @Default('Connected Bank Account') String connectedBankAccount,
    @Default('Beneficiary Details') String beneficiaryDetails,
    @Default('Close Account') String closeAccount,
    @Default('Old Password') String oldPassword,
    @Default('New Password') String newPassword,
    @Default('Update') String update,
    @Default('Bank Name') String bankName,
    @Default('Account Holder Name') String accountHolderName,
    @Default('Account Number') String accountNumber,
    @Default('Swift Code') String swiftCode,
    @Default('Edit Bank Details') String editBankDetails,
    @Default('Edit Beneficiary Details') String editBeneficiaryDetails,
    @Default('First Name') String firstName,
    @Default('Last Name') String lastName,
    @Default('Relationship') String relationship,
    @Default("Gender") String gender,
    @Default('City') String city,
    @Default('State') String state,
    @Default('Country') String country,
    @Default('Nationality') String nationality,
    @Default('Zip Code') String zipCode,
    @Default('Two-Factor Authentication') String twoFactorAuthentication,
    @Default('only if you have enabled 2FA') String onlyIfYouHaveEnabled2FA,
    @Default('Via SMS') String viaSMS,
    @Default('Primary number') String primaryNumber,
    @Default('Edit Details') String editDetails,
    @Default('Are you sure you want to close your account?')
    String areYouSureYouWantToCloseYourAccount,
    @Default('Yes, Sure') String yesSure,
    @Default('Cancel') String cancel,
    @Default('Username') String username,
    @Default('Password') String password,
    @Default('Forgot Password') String forgotPassword,
    @Default('By clicking "Login", I declare that I have read, understood and accepted')
    String byClickingLoginIDeclareThatIHaveReadUnderstoodAndAccepted,
    @Default('Terms & Conditions') String termsAndConditions,
    @Default('Language') String language,
    @Default('Login') String login,
    @Default('Don\'t have an account?') String dontHaveAnAccount,
    @Default('Register Now') String registerNow,
    @Default('Logout') String logout,
    @Default('Are you sure you want to logout?') String areYouSureYouWantToLogout,
    @Default('Select') String select,
    @Default('No data found') String noDataFound,
    @Default('Register a new member') String registerANewMember,
    @Default('Referral Name / Code') String referralNameOrCode,
    @Default('Confirm Password') String confirmPassword,
    @Default('Email') String email,
    @Default('Mobile Number') String mobileNumber,
    @Default('Address Line 1') String addressLine1,
    @Default('Address Line 2') String addressLine2,
    @Default('Postcode') String postCode,
    @Default('Already have an account?') String alreadyHaveAnAccount,
    @Default('Register') String register,
    @Default('Account') String account,
    @Default('Done') String done,
    @Default('LBMA Gold Price') String lbmagoldPrice,
    @Default('Your Referral Link') String yourReferralLink,
    @Default('Register User') String registerUser,
    @Default('-') String na,
    @Default('Commission Payout Setting') String commissionPayoutSetting,
    @Default('Select Date') String selectDate,
    @Default('Commission History') String commissionHistory,
    @Default('From Date') String fromDate,
    @Default('To Date') String toDate,
    @Default('Create Ticket') String createTicket,
    @Default('Subject') String subject,
    @Default('Description') String description,
    @Default('Submit') String submit,
    @Default('Severity') String severity,
    @Default('Support Type') String supportType,
    @Default('Wallet History') String walletHistory,
    @Default('My Referral') String myReferral,
    @Default('FAQ') String fAQ,
    @Default('Help Desk') String helpDesk,
    @Default('Referrer History') String referrerHistory,
    @Default('Transaction Type') String transactionType,
    @Default('The price has expired. Please try again.') String thePriceHasExpiredPleaseTryAgain,
    @Default('Insufficient Balance') String insufficientBalance,
    @Default('Top Up') String topUp,
    @Default('You have insufficient balance in your wallet. Please top up your wallet.')
    String youHaveInsufficientBalanceInYourWalletPleaseTopUpYourWallet,
    @Default('Confirm Your Buy') String confirmYourBuy,
    @Default('Confirm Buy') String confirmBuy,
    @Default('Success') String success,
    @Default(
        'By clicking "Confirm Buy", you enter into a binding contract to purchase the stated quantity of metal at the displayed price. QM will immediately charge for the total shown and deposit the corresponding metal into your account.')
    String
        byClickingConfirmBuyYouEnterIntoABindingContractToPurchaseTheStatedQuantityOfMetalAtTheDisplayedPriceQMWillImmediatelyChargeForTheTotalShownAndDepositTheCorrespondingMetalIntoYourAccount,
    @Default('Amount') String amount,
    @Default('Minimum order amount is') String minimumOrderAmountIs,
    @Default('Minimum order gram is') String minimumOrderGramIs,
    @Default('OR') String oR,
    @Default('Auto Trade') String autoTrade,
    @Default('Wallet Balance') String walletBalance,
    @Default('Add Fund') String addFund,
    @Default('Proceed') String proceed,
    @Default('Your pricing expires in') String yourPricingExpiresIn,
    @Default('Number of Unit') String numberOfUnit,
    @Default('Verify') String verify,
    @Default('Reverify') String reVerify,
    @Default('Total Deposits') String totalDeposits,
    @Default('Total Withdrawals') String totalWithdrawals,
    @Default('Select Trade') String selectTrade,
    @Default('Next') String next,
    @Default('Purchased Amount') String purchasedAmount,
    @Default('Sell Amount') String sellAmount,
    @Default('Loss') String loss,
    @Default('Profit') String profit,
    @Default('Fees') String fees,
    @Default('Purchase Date') String purchaseDate,
    @Default('KYC Verification is Pending') String kYCVerificationIsPending,
    @Default('KYC Verification is Under Review') String kYCVerificationIsUnderReview,
    @Default('KYC Verification Failed') String kYCVerificationFailed,
    @Default('Minimum Price') String minimumPrice,
    @Default('Confirm Sell') String confirmSell,
    @Default('Confirm Your Sell') String confirmYourSell,
    @Default(
        'By clicking "Confirm Sell", you are entering into a binding contract to sell the stated quantity of metal at the stated price. OneGold will immediately debit the total metal shown from your account and deposit the corresponding cash into your cash balance.')
    String
        byClickingConfirmSellYouAreEnteringIntoaBindingContractToSellTheStatedQuantityOfMetalAtTheStatedPriceOneGoldWillImmediatelyDebitTheTotalMetalShownFromYourAccountAndDepositTheCorrespondingCashIntoYourCashBalance,
    @Default('Gold Sell Amount') String goldSellAmount,
    @Default('Deposit Fund') String depositFund,
    @Default('Deposit Amount') String depositAmount,
    @Default('Payment Method') String paymentMethod,
    @Default('Confirm Your Convert') String confirmYourConvert,
    @Default('Confirm Convert') String confirmConvert,
    @Default('Convert Gold') String convertGold,
    @Default('Convert') String convert,
    @Default("You don't have enough gold to convert") String youDontHaveEnoughGoldToConvert,
    @Default("Weight") String weight,
    @Default("Withdraw Fund Review") String withdrawFundReview,
    @Default("Withdrawal Amount") String withdrawalAmount,
    @Default("Withdraw") String withdraw,
    @Default("Withdrawal Fees") String withdrawalFees,
    @Default("You will receive") String youWillReceive,
    @Default("Withdraw Fund") String withdrawFund,
    @Default("OTP Verification") String oTPVerification,
    @Default("Need to verify OTP sent on your mobile number. We have sent a verification code to")
    String needToVerifyOTPSentOnYourMobileNumberWeHaveSentaVerificationCodeTo,
    @Default("Phone number must be of exact 10 digits!!") String phoneNumberMustBeOfExact10Digits,
    @Default("Invalid phone number!") String invalidPhoneNumber,
    @Default("Invalid Email Address!") String invalidEmailAddress,
    @Default("Password must contain atleast 6 characters")
    String passwordMustContainAtleast6Characters,
    @Default("Legal Name") String legalName,
    @Default("KYC Verification") String kYCVerification,
    @Default("Continue") @JsonKey(name: 'continue') String $continue,
    @Default("Mobile OTP") String mobileOTP,
    @Default("Document Type") String documentType,
    @Default("Upload") String upload,
    @Default("Document Number") String documentNumber,
    @Default("Take a video") String takeAVideo,
    @Default("We’ll compare it with your document") String weWillCompareItWithYourDocument,
    @Default(
        "Please position yourself in front of the camera. Slowly turn your head to the left and then to the right within 10 seconds. Ensure your face is well-lit and centered. Thank you!")
    String
        pleasePositionYourselfInFrontOfTheCameraSlowlyTurnYourHeadToTheLeftAndThenToTheRightWithin10SecondsEnsureYourFaceIsWellLitAndCenteredThankYou,
    @Default("Remove your glasses, if necessary") String removeYourGlassesIfNecessary,
    @Default("Record") String record,
    @Default("Full Name") String fullName,
    @Default("As per the") String asPerThe,
    @Default("privacy policy") String privacyPolicy,
    @Default("I consent to collecting, using, and disclosing my personal information.")
    String iConsentToCollectingUsingAndDisclosingMyPersonalInformation,
    @Default("I agree to be bound by") String iAgreeToBeBoundBy,
    @Default("and accept the terms of the QM Gold Platform.")
    String andAcceptTheTermsOfTheQMGoldPlatform,
    @Default(
        "We want to assure you that we take your privacy seriously and that your personal information is safe. We will only use your details under our privacy policy. We use your information to provide our services and to send notifications about your account information, offers, and other things that may interest you.")
    String
        weWantToAssureYouThatWeTakeYourPrivacySeriouslyAndThatYourPersonalInformationIsSafeWeWillOnlyUseYourDetailsUnderOurPrivacyPolicyWeUseYourInformationToProvideOurServicesAndToSendNotificationsAboutYourAccountInformationOffersAndOtherThingsThatMayInterestYou,
    @Default("required!") String $required,
    @Default("Password does not match") String passwordDoesNotMatch,
    @Default("Income Range") String incomeRange,
    @Default("Occupation") String occupation,
    @Default(
        "To protect your account against unauthorized access, we strongly recommend that you enable two-factor authentication, so that your password alone is not enough to access your account.")
    String
        toProtectYourAccountAgainstUnauthorizedAccessWeStronglyRecommendThatYouEnableTwoFactorAuthenticationSoThatYourPasswordAloneIsNotEnoughToAccessYourAccount,
    @Default("Google Authenticator Code") String googleAuthenticatorCode,
    @Default("Primary Phone Number") String primaryPhoneNumber,
    @Default("Secondary Phone Number") String secondaryPhoneNumber,
    @Default("Gold Withdrawal Request") String goldWithdrawalRequest,
    @Default("Manage Recipient") String manageRecipient,
    @Default("Beneficiary Designation") String beneficiaryDesignation,
    @Default("Enable Face ID") String enableFaceID,
    @Default("Enable Fingerprint") String enableFingerprint,
    @Default("Enable Lock Screen") String enableLockScreen,
    @Default("Remove") String remove,
    @Default("Nominee Details") String nomineeDetails,
    @Default("Add Witness") String addWitness,
    @Default("Identification Type") String identificationType,
    @Default("Name") String name,
    @Default(
        "You can appoint 1 nominee in this form. If you wish to appoint more than 1 nominee, please visit the QM Service Centre.")
    String
        youCanAppoint1NomineeInThisFormIfYouWishToAppointMoreThan1NomineePleaseVisitTheQMServiceCentre,
    @Default("Please key in your nominee's name as per his/her identification documents.")
    String pleaseKeyInYourNomineesNameAsPerHisHerIdentificationDocuments,
    @Default("NRIC Number") String nricNumber,
    @Default("Foreign Identification Number") String foreignIdentificationNumber,
    @Default("Registration Number of Organisation") String registrationNumberOfOrganisation,
    @Default("Witnesses") String witnesses,
    @Default("Witness") String witness,
    @Default("Add Nominee") String addNominee,
    @Default(
        "Only organisations that are legal entities can be nominated. Find out what a legal entity is")
    String onlyOrganisationsThatAreLegalEntitiesCanBeNominatedFindOutWhatALegalEntityIs,
    @Default("here") String here,
    @Default("You can add") String youCanAdd,
    @Default("more nominees") String moreNominees,
    @Default("Remaining share is") String remainingShareIs,
    @Default("Add Recipient") String addRecipient,
    @Default("Recipient Number") String recipientNumber,
    @Default("Recipient Name") String recipientName,
    @Default("Recipient Email") String recipientEmail,
    @Default("Recipients") String recipients,
    @Default("Gold Convert") String goldConvert,
    @Default("Gold Convert Repayment") String goldConvertRepayment,
    @Default("Physical Gold Withdrawal") String physicalGoldWithdrawal,
    @Default("Gold Transfer") String goldTransfer,
    @Default("Deposit History") String depositHistory,
    @Default("Withdrawal History") String withdrawalHistory,
    @Default("Wallet Transactions") String walletTransactions,
    @Default("Gold Convert Account") String goldConvertAccount,
    @Default("Available Gold Convert") String availableGoldConvert,
    @Default("Available Gold Convert Value") String availableGoldConvertValue,
    @Default("GSA History") String gsaHistory,
    @Default("GAE History") String gaeHistory,
    @Default("Gold Holding") String goldHolding,
    @Default("Current Value") String currentValue,
    @Default("QM Member") String qmMember,
    @Default("Member Name") String memberName,
    @Default("Physical Withdrawal Country") String physicalWithdrawalCountry,
    @Default("Physical Withdrawal Region") String physicalWithdrawalRegion,
    @Default("Physical Withdrawal Branch") String physicalWithdrawalBranch,
    @Default("Delivery Address") String deliveryAddress,
    @Default("Branch Address") String branchAddress,
    @Default("Previous Step") String previousStep,
    @Default("Total Selected Gold Weight") String totalSelectedGoldWeight,
    @Default("Place Order") String placeOrder,
    @Default("Gold Weight") String goldWeight,
    @Default("Out of Stock") String outOfStock,
    @Default("Add to Cart") String addToCart,
    @Default("Exchange Rate") String exchangeRate,
  }) = _GetTranslationDataModel;

  factory GetTranslationDataModel.fromJson(Map<String, dynamic> json) =>
      _$GetTranslationDataModelFromJson(json);
}
