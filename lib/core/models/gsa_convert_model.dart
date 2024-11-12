class GetGSAConvertDetailsModel {
  dynamic orderDoc;
  List<({String? title, String? value})>? responseTotal;

  GetGSAConvertDetailsModel({this.orderDoc, this.responseTotal});

  GetGSAConvertDetailsModel.fromJson(Map<String, dynamic> json) {
    orderDoc = json['order_doc'];
    responseTotal = json['response_total']
            ?.map<({String? title, String? value})>(
                (v) => (title: v['title'] as String?, value: v['value']?.toString()))
            .toList() ??
        [];
  }

  @override
  String toString() =>
      'GetGSAConvertDetailsModel(orderDoc: $orderDoc, responseTotal: $responseTotal)';
}
