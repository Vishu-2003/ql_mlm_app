import 'package:qm_mlm_flutter/utils/constants.dart';
import 'package:qm_mlm_flutter/utils/extensions.dart';

class GetWalletTransactionModel {
  dynamic transactionDatetime;
  dynamic transactionType;
  dynamic amount;
  dynamic balance;
  dynamic modeOfPayment;
  dynamic bankName;
  dynamic bankAccountHolderName;
  dynamic accountNumber;
  dynamic ifscCode;
  dynamic transactionNature;
  dynamic status;
  dynamic remarks;
  dynamic exchangeRate;

  GetWalletTransactionModel({
    this.transactionDatetime,
    this.transactionType,
    this.amount,
    this.balance,
    this.modeOfPayment,
    this.bankName,
    this.bankAccountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.transactionNature,
    this.status,
    this.remarks,
    this.exchangeRate,
  });

  GetWalletTransactionModel.fromJson(Map<String, dynamic> json) {
    transactionDatetime = json['transaction_datetime'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    balance = json['balance'];
    modeOfPayment = json['mode_of_payment'];
    bankName = json['bank_name'];
    bankAccountHolderName = json['bank_account_holder_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    transactionNature = json['transaction_nature'];
    status = json['status'];
    remarks = json['remarks'];
    exchangeRate = json['exchange_rate'];
  }

  @override
  String toString() {
    return 'GetWalletTransactionModel(transactionDatetime: $transactionDatetime, transactionType: $transactionType, amount: $amount, balance: $balance, modeOfPayment: $modeOfPayment, bankName: $bankName, bankAccountHolderName: $bankAccountHolderName, accountNumber: $accountNumber, ifscCode: $ifscCode, transactionNature: $transactionNature, status: $status, remarks: $remarks)';
  }
}

class WalletTransactionFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;
  String? transactionType;

  WalletTransactionFilterModel({
    required this.start,
    required this.pageLength,
    this.toDate,
    this.fromDate,
    this.transactionType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
      if (!isNullEmptyOrFalse(transactionType)) 'transaction_type': transactionType,
      if (!isNullEmptyOrFalse(fromDate)) 'from_date': fromDate?.getDefaultDateFormat,
      if (!isNullEmptyOrFalse(toDate)) 'to_date': toDate?.getDefaultDateFormat,
    };
  }

  @override
  String toString() {
    return 'WalletTransactionFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate, transactionType: $transactionType)';
  }
}
