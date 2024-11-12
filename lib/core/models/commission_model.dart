import 'package:qm_mlm_flutter/utils/utils.dart';

class GetCommissionModel {
  String? date;
  String? transactionType;
  String? amount;
  String? fromAccount;
  String? remarks;

  GetCommissionModel({
    this.date,
    this.transactionType,
    this.amount,
    this.fromAccount,
    this.remarks,
  });

  GetCommissionModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    fromAccount = json['from_account'];
    remarks = json['remarks'];
  }

  @override
  String toString() {
    return 'GetCommissionModel(date: $date, transactionType: $transactionType, amount: $amount, fromAccount: $fromAccount, remarks: $remarks)';
  }
}

class CommissionHistoryFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;

  CommissionHistoryFilterModel({
    required this.start,
    required this.pageLength,
    this.toDate,
    this.fromDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
      if (!isNullEmptyOrFalse(fromDate)) 'from_date': fromDate?.getDefaultDateFormat,
      if (!isNullEmptyOrFalse(toDate)) 'to_date': toDate?.getDefaultDateFormat,
    };
  }

  @override
  String toString() {
    return 'CommissionHistoryFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate)';
  }
}
