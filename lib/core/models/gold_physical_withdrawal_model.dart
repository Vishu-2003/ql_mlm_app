import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

part 'gold_physical_withdrawal_model.freezed.dart';
part 'gold_physical_withdrawal_model.g.dart';

@Freezed(toJson: false, copyWith: false)
class GetGoldPhysicalWithdrawalDataModel with _$GetGoldPhysicalWithdrawalDataModel {
  @JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
  const factory GetGoldPhysicalWithdrawalDataModel({
    String? qmMember,
    String? goldPrice,
    String? memberName,
    String? balanceBeforeRequest,
    String? baseBalanceBeforeRequest,
    double? balanceBeforeRequestInValue,
  }) = _GetGoldPhysicalWithdrawalDataModel;

  factory GetGoldPhysicalWithdrawalDataModel.fromJson(Map<String, dynamic> json) =>
      _$GetGoldPhysicalWithdrawalDataModelFromJson(json);
}

class GetGoldPhysicalWithdrawalBranchModel {
  String? name;
  String? branch;
  String? branchAddress;
  bool? isDelivery;

  GetGoldPhysicalWithdrawalBranchModel({
    this.name,
    this.branch,
    this.branchAddress,
    this.isDelivery,
  });

  GetGoldPhysicalWithdrawalBranchModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    branch = json['branch'];
    branchAddress = json['branch_address'];
    isDelivery = json['is_delivery'] == 1;
  }

  @override
  String toString() {
    return 'GetGoldPhysicalWithdrawalBranchList(name: $name, branch: $branch, branchAddress: $branchAddress, isDelivery: $isDelivery)';
  }
}

class GetGoldPhysicalWithdrawalDeliveryDetailsModel {
  String? address;
  String? mobile;

  GetGoldPhysicalWithdrawalDeliveryDetailsModel({this.address, this.mobile});

  GetGoldPhysicalWithdrawalDeliveryDetailsModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mobile = json['mobile'];
  }

  @override
  String toString() =>
      'GetGoldPhysicalWithdrawalDeliveryDetailsModel(address: $address, mobile: $mobile)';
}

class GetGoldPhysicalWithdrawalItemModel {
  String? itemCode;
  String? description;
  String? image;
  double? goldWeight;
  dynamic stockBalance;

  GetGoldPhysicalWithdrawalItemModel({
    this.itemCode,
    this.description,
    this.image,
    this.goldWeight,
    this.stockBalance,
  });

  GetGoldPhysicalWithdrawalItemModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    description = json['description'];
    image = json['image'];
    goldWeight = json['gold_weight'];
    stockBalance = json['stock_balance'];
  }

  @override
  String toString() {
    return 'GetGoldPhysicalWithdrawalItemsModel(itemCode: $itemCode, description: $description, image: $image, goldWeight: $goldWeight, stockBalance: $stockBalance)';
  }

  @override
  bool operator ==(covariant GetGoldPhysicalWithdrawalItemModel other) {
    if (identical(this, other)) return true;

    return other.itemCode == itemCode &&
        other.description == description &&
        other.image == image &&
        other.goldWeight == goldWeight &&
        other.stockBalance == stockBalance;
  }

  @override
  int get hashCode {
    return itemCode.hashCode ^
        description.hashCode ^
        image.hashCode ^
        goldWeight.hashCode ^
        stockBalance.hashCode;
  }
}

class PostGoldPhysicalWithdrawalOrderModel {
  String? country;
  String? region;
  String? branch;
  String? branchAddress;
  String? deliveryAddress;
  String? mobileNo;
  List<PostGoldPhysicalWithdrawalOrderItemModel>? items;

  PostGoldPhysicalWithdrawalOrderModel({
    required this.country,
    required this.region,
    required this.branch,
    required this.branchAddress,
    required this.deliveryAddress,
    required this.mobileNo,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['country'] = country;
    data['region'] = region;
    data['branch'] = branch;
    if (!isNullEmptyOrFalse(branchAddress)) data['branch_address'] = branchAddress;
    if (!isNullEmptyOrFalse(deliveryAddress)) data['delivery_address'] = deliveryAddress;
    data['mobile_no'] = mobileNo;
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostGoldPhysicalWithdrawalOrderItemModel {
  String? goldPhysicalWithdrawalItem;
  int? qty;

  PostGoldPhysicalWithdrawalOrderItemModel({this.goldPhysicalWithdrawalItem, this.qty});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['gold_physical_withdrawal_item'] = goldPhysicalWithdrawalItem;
    data['qty'] = qty;
    return data;
  }
}

@Freezed(toJson: false)
class GetPhysicalGoldWithdrawalRequestModel with _$GetPhysicalGoldWithdrawalRequestModel {
  const GetPhysicalGoldWithdrawalRequestModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetPhysicalGoldWithdrawalRequestModel({
    @JsonKey(name: 'name') required String id,
    dynamic date,
    dynamic status,
    dynamic country,
    dynamic region,
    dynamic branch,
    dynamic mobileNo,
    dynamic goldPrice,
    dynamic totalPrice,
    dynamic branchAddress,
    dynamic deliveryAddress,
    dynamic totalGoldWeight,
    dynamic balanceBeforeRequest,
    dynamic balanceBeforeRequestInValue,
    @Default([]) List<GetPhysicalGoldWithdrawalRequestItemModel> items,
  }) = _GetPhysicalGoldWithdrawalRequestModel;

  factory GetPhysicalGoldWithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetPhysicalGoldWithdrawalRequestModelFromJson(json);

  Color get statusColor {
    return switch (status) {
      "Pending" => getPrimaryColor,
      "Approved" => Colors.green,
      "Rejected" => Colors.red,
      _ => getGrey1,
    };
  }
}

@Freezed(toJson: false)
class GetPhysicalGoldWithdrawalRequestItemModel with _$GetPhysicalGoldWithdrawalRequestItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory GetPhysicalGoldWithdrawalRequestItemModel({
    @JsonKey(name: 'name') required String id,
    dynamic qty,
    dynamic image,
    dynamic goldWeight,
    dynamic description,
    dynamic totalGoldWeight,
    dynamic goldPhysicalWithdrawalItem,
  }) = _GetPhysicalGoldWithdrawalRequestItemModel;

  factory GetPhysicalGoldWithdrawalRequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$GetPhysicalGoldWithdrawalRequestItemModelFromJson(json);
}
