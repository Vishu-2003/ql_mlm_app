import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/core/services/gs_services.dart';

part 'logging_interceptor.dart';

class ApiInterceptor implements Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _attachAuthToken(options);
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  void _attachAuthToken(RequestOptions options) async {
    if (!options.extra.containsKey("requiresToken") || !options.extra['requiresToken']) return;

    options.extra.remove("requiresToken");

    final String? apiKey = GSServices.getUser?.keyDetails?.apiKey;
    final String? apiSecret = GSServices.getUser?.keyDetails?.apiSecret;

    options.headers.addAll({"Authorization": 'token $apiKey:$apiSecret'});
  }
}
