class GetWithdrawalInformationModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? member;
  String? user;
  int? chargesPercentage;
  double? amount;
  String? date;
  double? charges;
  double? actualAmount;
  String? bankName;
  String? bankAccountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? doctype;

  GetWithdrawalInformationModel({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.member,
    this.user,
    this.chargesPercentage,
    this.amount,
    this.date,
    this.charges,
    this.actualAmount,
    this.bankName,
    this.bankAccountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.doctype,
  });

  GetWithdrawalInformationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    member = json['member'];
    user = json['user'];
    chargesPercentage = json['charges_percentage'];
    amount = json['amount'];
    date = json['date'];
    charges = json['charges'];
    actualAmount = json['actual_amount'];
    bankName = json['bank_name'];
    bankAccountHolderName = json['bank_account_holder_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    doctype = json['doctype'];
  }

  @override
  String toString() {
    return 'GetWithdrawalInformationModel(name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, member: $member, user: $user, chargesPercentage: $chargesPercentage, amount: $amount, date: $date, charges: $charges, actualAmount: $actualAmount, bankName: $bankName, bankAccountHolderName: $bankAccountHolderName, accountNumber: $accountNumber, ifscCode: $ifscCode, doctype: $doctype)';
  }
}

class PostWithdrawFundModel {
  int? chargesPercentage;
  double? amount;
  double? charges;
  double? actualAmount;
  String? bankName;
  String? bankAccountHolderName;
  String? accountNumber;
  String? ifscCode;

  PostWithdrawFundModel({
    required this.chargesPercentage,
    required this.amount,
    required this.charges,
    required this.actualAmount,
    required this.bankName,
    required this.bankAccountHolderName,
    required this.accountNumber,
    required this.ifscCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['charges_percentage'] = chargesPercentage;
    data['amount'] = amount;
    data['charges'] = charges;
    data['actual_amount'] = actualAmount;
    data['bank_name'] = bankName;
    data['bank_account_holder_name'] = bankAccountHolderName;
    data['account_number'] = accountNumber;
    data['ifsc_code'] = ifscCode;
    return data;
  }

  @override
  String toString() {
    return 'PostWithdrawFundModel(chargesPercentage: $chargesPercentage, amount: $amount, charges: $charges, actualAmount: $actualAmount, bankName: $bankName, bankAccountHolderName: $bankAccountHolderName, accountNumber: $accountNumber, ifscCode: $ifscCode)';
  }
}
