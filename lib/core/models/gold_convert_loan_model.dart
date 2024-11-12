class GetGoldConvertLoanModel {
  String? name;
  double? amount;
  dynamic amountLabel;
  double? outstandingAmount;
  dynamic outstandingAmountLabel;
  double? paidAmount;
  dynamic paidAmountLabel;
  double? gsaGold;
  double? gcaGold;
  List<RepaymentDetails>? repaymentDetails;

  GetGoldConvertLoanModel({
    this.name,
    this.amount,
    this.outstandingAmount,
    this.paidAmount,
    this.gsaGold,
    this.gcaGold,
    this.repaymentDetails,
    this.amountLabel,
    this.outstandingAmountLabel,
    this.paidAmountLabel,
  });

  GetGoldConvertLoanModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    outstandingAmount = json['outstanding_amount'];
    paidAmount = json['paid_amount'];
    gsaGold = json['gsa_gold'];
    gcaGold = json['gca_gold'];
    amountLabel = json['amount_label'];
    outstandingAmountLabel = json['outstanding_amount_label'];
    paidAmountLabel = json['paid_amount_label'];
    if (json['repayment_details'] != null) {
      repaymentDetails = <RepaymentDetails>[];
      json['repayment_details'].forEach((v) {
        repaymentDetails!.add(RepaymentDetails.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'GetGoldConvertLoanModel(name: $name, amount: $amount, amountLabel: $amountLabel, outstandingAmount: $outstandingAmount, outstandingAmountLabel: $outstandingAmountLabel, paidAmount: $paidAmount, paidAmountLabel: $paidAmountLabel, gsaGold: $gsaGold, gcaGold: $gcaGold, repaymentDetails: $repaymentDetails)';
  }
}

class RepaymentDetails {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? goldConvertRepayment;
  String? date;
  double? paidAmount;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  RepaymentDetails({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.goldConvertRepayment,
    this.date,
    this.paidAmount,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.doctype,
  });

  RepaymentDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    goldConvertRepayment = json['gold_convert_repayment'];
    date = json['date'];
    paidAmount = json['paid_amount'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  @override
  String toString() {
    return 'RepaymentDetails(name: $name, owner: $owner, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, goldConvertRepayment: $goldConvertRepayment, date: $date, paidAmount: $paidAmount, parent: $parent, parentfield: $parentfield, parenttype: $parenttype, doctype: $doctype)';
  }
}

class PostGoldConvertRepaymentModel {
  String? qmConvertOrder;
  double? amount;
  double? outstandingAmount;
  double? paidAmount;

  PostGoldConvertRepaymentModel({
    this.qmConvertOrder,
    this.amount,
    this.outstandingAmount,
    this.paidAmount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['qm_convert_order'] = qmConvertOrder;
    data['amount'] = amount;
    data['outstanding_amount'] = outstandingAmount;
    data['paid_amount'] = paidAmount;
    return data;
  }

  @override
  String toString() {
    return 'GoldConvertRepaymentDetails(qmConvertOrder: $qmConvertOrder, amount: $amount, outstandingAmount: $outstandingAmount, paidAmount: $paidAmount)';
  }
}
