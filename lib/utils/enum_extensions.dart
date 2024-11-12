import 'package:qm_mlm_flutter/utils/enums.dart';

extension GoldWithdrawalShippingTypeE7n on GoldWithdrawalShippingType {
  String toMap() {
    return switch (this) {
      GoldWithdrawalShippingType.delivery => 'Delivery',
      GoldWithdrawalShippingType.selfCollection => 'Self Collection',
    };
  }
}
