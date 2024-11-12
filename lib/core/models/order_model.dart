import 'package:qm_mlm_flutter/utils/utils.dart';

class GetOrderModel {
  String? name;
  String? orderDate;
  String? orderTime;
  String? member;
  String? orderType;
  String? tradingItem;
  double? unit;
  double? price;
  double? estimatedGold;
  String? transactionType;
  String? postingDate;
  String? postingTime;
  double? qty;
  double? totalPrice;
  double? totalEstimatedGold;
  double? productX;
  double? contractUnit;
  double? contractPrice;
  double? contractWeight;
  double? contractAmount;
  double? downPayment;
  double? flexiblePayment;
  double? fixedPayment;
  String? qmGoldContract;
  String? itemType;

  GetOrderModel({
    this.name,
    this.orderDate,
    this.orderTime,
    this.member,
    this.orderType,
    this.tradingItem,
    this.unit,
    this.price,
    this.estimatedGold,
    this.transactionType,
    this.postingDate,
    this.postingTime,
    this.qty,
    this.totalPrice,
    this.totalEstimatedGold,
    this.productX,
    this.contractUnit,
    this.contractPrice,
    this.contractWeight,
    this.contractAmount,
    this.downPayment,
    this.flexiblePayment,
    this.fixedPayment,
    this.qmGoldContract,
    this.itemType,
  });

  GetOrderModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    orderDate = json['order_date'];
    orderTime = json['order_time'];
    member = json['member'];
    orderType = json['order_type'];
    tradingItem = json['trading_item'];
    unit = json['unit'];
    price = json['price'];
    estimatedGold = json['estimated_gold'];
    transactionType = json['transaction_type'];
    postingDate = json['posting_date'];
    postingTime = json['posting_time'];
    qty = json['qty'];
    totalPrice = json['total_price'];
    totalEstimatedGold = json['total_estimated_gold'];
    productX = json['product_x'];
    contractUnit = json['contract_unit'];
    contractPrice = json['contract_price'];
    contractWeight = json['contract_weight'];
    contractAmount = json['contract_amount'];
    downPayment = json['down_payment'];
    flexiblePayment = json['flexible_payment'];
    fixedPayment = json['fixed_payment'];
    qmGoldContract = json['qm_gold_contract'];
    itemType = json['item_type'];
  }

  @override
  String toString() {
    return 'GetOrderModel(name: $name, orderDate: $orderDate, orderTime: $orderTime, member: $member, orderType: $orderType, tradingItem: $tradingItem, unit: $unit, price: $price, estimatedGold: $estimatedGold, transactionType: $transactionType, postingDate: $postingDate, postingTime: $postingTime, qty: $qty, totalPrice: $totalPrice, totalEstimatedGold: $totalEstimatedGold, productX: $productX, contractUnit: $contractUnit, contractPrice: $contractPrice, contractWeight: $contractWeight, contractAmount: $contractAmount, downPayment: $downPayment, flexiblePayment: $flexiblePayment, fixedPayment: $fixedPayment, qmGoldContract: $qmGoldContract, itemType: $itemType)';
  }
}

class OrdersFilterModel {
  final String? item;
  final String? orderId;
  final OrderType? orderType;

  OrdersFilterModel({
    this.item,
    this.orderId,
    this.orderType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!isNullEmptyOrFalse(orderId)) 'name': orderId,
      if (!isNullEmptyOrFalse(item)) 'trading_item': item,
      if (orderType != null) 'transaction_type': orderType == OrderType.buy ? 'Buy' : 'Sell',
    };
  }

  @override
  String toString() => 'OrdersFilterModel(item: $item, orderId: $orderId, orderType: $orderType)';
}

class GetBuyOrderDetailsModel {
  dynamic orderDoc;
  List<({String? title, String? value, String? value2})>? responseTotal;

  GetBuyOrderDetailsModel({this.orderDoc, this.responseTotal});

  GetBuyOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    orderDoc = json['order_doc'];
    responseTotal = json['response_total']
            ?.map<({String? title, String? value, String? value2})>((v) => (
                  title: v['title'] as String?,
                  value: v['value']?.toString(),
                  value2: v['value_2']?.toString()
                ))
            .toList() ??
        [];
  }

  @override
  String toString() =>
      'GetBuyOrderDetailsModel(orderDoc: $orderDoc, responseTotal: $responseTotal)';
}

class GetSellOrderDetailsModel {
  dynamic orderDoc;
  List<({String? title, String? value, String? value2})>? responseTotal;

  GetSellOrderDetailsModel({this.orderDoc, this.responseTotal});

  GetSellOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    orderDoc = json['order_doc'];
    responseTotal = json['response_total']
            ?.map<({String? title, String? value, String? value2})>((v) => (
                  title: v['title'] as String?,
                  value: v['value']?.toString(),
                  value2: v['value_2']?.toString()
                ))
            .toList() ??
        [];
  }

  @override
  String toString() =>
      'GetSellOrderDetailsModel(orderDoc: $orderDoc, responseTotal: $responseTotal)';
}

class PostSellOrderDetailsContractModel {
  String? item;
  bool? autoTrade;
  double? autoTradePrice;
  List<Contracts>? contracts;

  PostSellOrderDetailsContractModel({
    this.item,
    this.contracts,
    this.autoTrade,
    this.autoTradePrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['item'] = item;
    if (autoTrade == true) data['auto_trade'] = autoTrade;
    if (autoTrade == true) data['auto_trade_price'] = autoTradePrice;
    if (contracts != null) {
      data['contracts'] = contracts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => 'PostSellOrderDetailsContractModel(item: $item, contracts: $contracts)';
}

class Contracts {
  String? name;
  double? qty;

  Contracts({required this.name, required this.qty});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['qty'] = qty;
    return data;
  }

  @override
  String toString() => 'Contracts(name: $name, qty: $qty)';
}
