import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@Freezed(copyWith: false)
class GetItemModel with _$GetItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetItemModel({
    String? name,
    String? creation,
    String? modified,
    String? modifiedBy,
    String? owner,
    String? itemName,
    String? baseUnitPrice,
    String? unitPrice,
    double? unitPriceVal,
    String? itemCode,
    double? downPaymentPerc,
    String? baseGoldPrice,
    String? goldPrice,
    double? estimatedGold,
    String? itemType,
    double? contractX,
    double? spread,
    double? sellingPrice,
    double? flexiblePayment,
    double? managementFees,
    String? image,
    String? itemInformation,
    String? terms,
    String? metal,
  }) = _GetItemModel;

  factory GetItemModel.fromJson(Map<String, dynamic> json) => _$GetItemModelFromJson(json);
}
