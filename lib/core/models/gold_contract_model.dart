import 'package:freezed_annotation/freezed_annotation.dart';

part 'gold_contract_model.freezed.dart';
part 'gold_contract_model.g.dart';

@Freezed(copyWith: false)
class GetGoldContractModel with _$GetGoldContractModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetGoldContractModel({
    @JsonKey(name: 'name') required String id,
    double? qty,
    String? fees,
    String? profitLoss,
    String? purchaseDate,
    double? profitLossVal,
    double? estimatedGold,
    String? sellingAmount,
    String? purchaseAmount,
    String? baseSellingAmount,
    String? basePurchaseAmount,
  }) = _GetGoldContractModel;

  factory GetGoldContractModel.fromJson(Map<String, dynamic> json) =>
      _$GetGoldContractModelFromJson(json);
}
