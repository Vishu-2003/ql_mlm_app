import 'package:qm_mlm_flutter/utils/utils.dart';

class GetTransactionModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  String? postingDate;
  String? postingTime;
  String? member;
  String? transactionType;
  String? tradingItem;
  double? unit;
  double? price;
  double? estimatedGold;
  double? totalEstimatedGold;
  double? totalPrice;
  double? memberGoldAfterTransaction;
  String? qmOrder;
  double? isCancelled;
  double? qty;

  GetTransactionModel({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.owner,
    this.postingDate,
    this.postingTime,
    this.member,
    this.transactionType,
    this.tradingItem,
    this.unit,
    this.price,
    this.estimatedGold,
    this.totalEstimatedGold,
    this.totalPrice,
    this.memberGoldAfterTransaction,
    this.qmOrder,
    this.isCancelled,
    this.qty,
  });

  GetTransactionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    postingDate = json['posting_date'];
    postingTime = json['posting_time'];
    member = json['member'];
    transactionType = json['transaction_type'];
    tradingItem = json['trading_item'];
    unit = json['unit'];
    price = json['price'];
    estimatedGold = json['estimated_gold'];
    totalEstimatedGold = json['total_estimated_gold'];
    totalPrice = json['total_price'];
    memberGoldAfterTransaction = json['member_gold_after_transaction'];
    qmOrder = json['qm_order'];
    isCancelled = json['is_cancelled'];
    qty = json['qty'];
  }

  @override
  String toString() {
    return 'GetTransactionModel(name: $name, creation: $creation, modified: $modified, modifiedBy: $modifiedBy, owner: $owner, postingDate: $postingDate, postingTime: $postingTime, member: $member, transactionType: $transactionType, tradingItem: $tradingItem, unit: $unit, price: $price, estimatedGold: $estimatedGold, totalEstimatedGold: $totalEstimatedGold, totalPrice: $totalPrice, memberGoldAfterTransaction: $memberGoldAfterTransaction, qmOrder: $qmOrder, isCancelled: $isCancelled, qty: $qty)';
  }
}

class TransactionsFilterModel {
  final String? item;
  final String? transactionId;
  final TransactionType? transactionType;

  TransactionsFilterModel({
    this.item,
    this.transactionId,
    this.transactionType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!isNullEmptyOrFalse(item)) 'trading_item': item,
      if (!isNullEmptyOrFalse(transactionId)) 'name': transactionId,
      if (transactionType != null)
        'transaction_type': transactionType == TransactionType.buy ? 'Buy' : 'Sell',
    };
  }

  @override
  String toString() =>
      'TransactionsFilterModel(item: $item, transactionId: $transactionId, transactionType: $transactionType)';
}
