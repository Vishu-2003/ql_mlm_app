import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

part 'history_models.freezed.dart';
part 'history_models.g.dart';

@Freezed(toJson: false, copyWith: false, equal: false)
class GetTradeHistoryModel with _$GetTradeHistoryModel {
  const GetTradeHistoryModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetTradeHistoryModel({
    dynamic product,
    dynamic estimatedGold,
    dynamic totalAmount,
    dynamic downPayment,
    dynamic flexiPayment,
    dynamic orderDate,
    dynamic orderTime,
    dynamic flexiPaymentDate,
    dynamic transactionType,
    dynamic status,
    dynamic qty,
    dynamic exchangeRate,
    dynamic member,
  }) = _GetTradeHistoryModel;

  factory GetTradeHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$GetTradeHistoryModelFromJson(json);

  Color get getTransactionTypeColor {
    switch (transactionType) {
      case 'Buy':
        return green;
      case 'Sell':
        return lightRed;
      default:
        return grey1;
    }
  }

  Color get getStatusColor {
    switch (status) {
      case 'Confirmed':
        return green;
      case 'Pending':
        return yellow;
      default:
        return grey1;
    }
  }
}

class TradeHistoryFilterModel {
  int start;
  int pageLength;
  String? member;
  DateTime? toDate;
  DateTime? fromDate;
  String? transactionType;

  TradeHistoryFilterModel({
    required this.start,
    required this.pageLength,
    this.toDate,
    this.fromDate,
    this.member,
    this.transactionType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
      if (!isNullEmptyOrFalse(member)) 'member': member,
      if (!isNullEmptyOrFalse(toDate)) 'to_date': toDate?.getDefaultDateFormat,
      if (!isNullEmptyOrFalse(transactionType)) 'transaction_type': transactionType,
      if (!isNullEmptyOrFalse(fromDate)) 'from_date': fromDate?.getDefaultDateFormat,
    };
  }

  @override
  String toString() {
    return 'TradeHistoryFilterModel(start: $start, pageLength: $pageLength, member: $member, toDate: $toDate, fromDate: $fromDate, transactionType: $transactionType)';
  }
}

class GetDepositHistoryModel {
  dynamic date;
  dynamic amount;
  dynamic modeOfPayment;
  dynamic status;
  dynamic remarks;
  dynamic exchangeRate;

  GetDepositHistoryModel({
    this.date,
    this.amount,
    this.modeOfPayment,
    this.status,
    this.remarks,
    this.exchangeRate,
  });

  GetDepositHistoryModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = json['amount'];
    modeOfPayment = json['mode_of_payment'];
    status = json['status'];
    remarks = json['remarks'];
    exchangeRate = json['exchange_rate'];
  }

  Color get getStatsColor {
    switch (status) {
      case 'Completed':
        return green;
      case 'Pending':
        return yellow;
      default:
        return grey1;
    }
  }

  @override
  String toString() {
    return 'GetDepositHistoryModel(date: $date, amount: $amount, modeOfPayment: $modeOfPayment, status: $status, remarks: $remarks, exchangeRate: $exchangeRate)';
  }
}

class DepositHistoryFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;

  DepositHistoryFilterModel({
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
    return 'DepositHistoryFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate)';
  }
}

class GetWithdrawalHistoryModel {
  dynamic date;
  dynamic amount;
  dynamic charges;
  dynamic actualAmount;
  dynamic bankName;
  dynamic bankAccountHolderName;
  dynamic accountNumber;
  dynamic swiftCode;
  dynamic status;
  dynamic exchangeRate;

  GetWithdrawalHistoryModel({
    this.date,
    this.amount,
    this.charges,
    this.actualAmount,
    this.bankName,
    this.bankAccountHolderName,
    this.accountNumber,
    this.swiftCode,
    this.status,
    this.exchangeRate,
  });

  GetWithdrawalHistoryModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = json['amount'];
    charges = json['charges'];
    actualAmount = json['actual_amount'];
    bankName = json['bank_name'];
    bankAccountHolderName = json['bank_account_holder_name'];
    accountNumber = json['account_number'];
    swiftCode = json['swift_code'];
    status = json['status'];
    exchangeRate = json['exchange_rate'];
  }

  Color get getStatsColor {
    switch (status) {
      case 'Approved':
        return green;
      case 'Pending':
        return yellow;
      default:
        return grey1;
    }
  }

  @override
  String toString() {
    return 'GetWithdrawalHistoryModel(date: $date, amount: $amount, charges: $charges, actualAmount: $actualAmount, bankName: $bankName, bankAccountHolderName: $bankAccountHolderName, accountNumber: $accountNumber, swiftCode: $swiftCode, status: $status, exchangeRate: $exchangeRate)';
  }
}

class WithdrawalHistoryFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;

  WithdrawalHistoryFilterModel({
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
    return 'WithdrawalHistoryFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate)';
  }
}

class GetGSAHistoryModel {
  dynamic orderDate;
  dynamic amount;
  dynamic goldRate;
  dynamic estimatedGold;
  dynamic totalGsaBalance;
  dynamic transactionId;
  dynamic transactionType;
  dynamic receivedFrom;
  dynamic transferTo;
  dynamic exchangeRate;

  GetGSAHistoryModel({
    this.orderDate,
    this.amount,
    this.goldRate,
    this.estimatedGold,
    this.totalGsaBalance,
    this.transactionId,
    this.transactionType,
    this.receivedFrom,
    this.transferTo,
    this.exchangeRate,
  });

  GetGSAHistoryModel.fromJson(Map<String, dynamic> json) {
    orderDate = json['order_date'];
    amount = json['amount'];
    goldRate = json['gold_rate'];
    estimatedGold = json['estimated_gold'];
    totalGsaBalance = json['total_gsa_balance'];
    transactionId = json['transaction_id'];
    transactionType = json['transaction_type'];
    receivedFrom = json['received_from'];
    transferTo = json['transfer_to'];
    exchangeRate = json['exchange_rate'];
  }

  Color get getTransactionTypeColor {
    switch (transactionType) {
      case 'Buy':
      case 'Gold Received':
        return green;
      case 'Sell':
      case 'Gold Transfer':
        return lightRed;
      case 'Convert':
        return getPrimaryColor;
      default:
        return grey1;
    }
  }

  @override
  String toString() {
    return 'GetGSAHistoryModel(orderDate: $orderDate, amount: $amount, goldRate: $goldRate, estimatedGold: $estimatedGold, totalGsaBalance: $totalGsaBalance, transactionId: $transactionId, transactionType: $transactionType, receivedFrom: $receivedFrom, transferTo: $transferTo, exchangeRate: $exchangeRate)';
  }
}

class GSAHistoryFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;
  String? transactionType;

  GSAHistoryFilterModel({
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
    return 'GSAHistoryFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate, transactionType: $transactionType)';
  }
}

@Freezed(toJson: false, copyWith: false)
class GetAutoTradeOrderHistoryModel with _$GetAutoTradeOrderHistoryModel {
  const GetAutoTradeOrderHistoryModel._();

  @JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
  const factory GetAutoTradeOrderHistoryModel({
    @JsonKey(name: 'name') required String id,
    dynamic postingDate,
    dynamic postingTime,
    dynamic transactionType,
    dynamic tradingItem,
    dynamic autoTradePrice,
    dynamic itemType,
    dynamic totalPrice,
    dynamic flexiblePayment,
    dynamic downPayment,
    dynamic contractPrice,
    dynamic totalEstimatedGold,
    dynamic contractWeight,
    dynamic status,
    dynamic exchangeRate,
  }) = _GetAutoTradeOrderHistoryModel;

  factory GetAutoTradeOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$GetAutoTradeOrderHistoryModelFromJson(json);

  Color get getStatsColor {
    switch (status) {
      case 'Confirmed':
        return green;
      case 'Pending':
        return yellow;
      default:
        return grey1;
    }
  }
}

class AutoTradeOrderFilterModel {
  int start;
  int pageLength;
  DateTime? toDate;
  DateTime? fromDate;
  String? itemType;

  AutoTradeOrderFilterModel({
    required this.start,
    required this.pageLength,
    this.toDate,
    this.fromDate,
    this.itemType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
      if (!isNullEmptyOrFalse(itemType)) 'item_type': itemType,
      if (!isNullEmptyOrFalse(fromDate)) 'from_date': fromDate?.getDefaultDateFormat,
      if (!isNullEmptyOrFalse(toDate)) 'to_date': toDate?.getDefaultDateFormat,
    };
  }

  @override
  String toString() {
    return 'AutoTradeOrderFilterModel(start: $start, pageLength: $pageLength, toDate: $toDate, fromDate: $fromDate, itemType: $itemType)';
  }
}
