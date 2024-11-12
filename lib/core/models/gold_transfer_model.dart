import 'package:qm_mlm_flutter/utils/utils.dart';

class PostGoldTransferModel {
  String? toAccount;
  String? transferMode;
  double? amount;
  double? gram;
  String? description;

  PostGoldTransferModel({
    this.toAccount,
    this.transferMode,
    this.amount,
    this.gram,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['to_account'] = toAccount;
    data['transfer_mode'] = transferMode;
    if (!isNullEmptyOrFalse(amount)) data['amount'] = amount;
    if (!isNullEmptyOrFalse(gram)) data['gram'] = gram;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return 'PostGoldTransferModel(toAccount: $toAccount, transferMode: $transferMode, amount: $amount, gram: $gram, description: $description)';
  }
}
