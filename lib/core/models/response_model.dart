import 'package:dio/dio.dart';

import '../../utils/extensions.dart';

class GetResponseModel<T> {
  T? data;
  final bool isSuccess;
  final int? statusCode;
  final String? message;

  GetResponseModel({
    this.data,
    this.message,
    this.statusCode,
    this.isSuccess = false,
  });

  GetResponseModel<T> copyWith({
    T? data,
    String? message,
    bool? isSuccess,
    int? statusCode,
  }) {
    return GetResponseModel<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  factory GetResponseModel.fromResponse(Response<dynamic> response) {
    return GetResponseModel<T>(
      isSuccess: response.isSuccess,
      statusCode: response.statusCode,
      message: response.data['message'] != null ? response.data['message'] as String : null,
    );
  }

  @override
  String toString() {
    return 'GetResponseModel(data: $data, isSuccess: $isSuccess, statusCode: $statusCode, message: $message)';
  }
}
