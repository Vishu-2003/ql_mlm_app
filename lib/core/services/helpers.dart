import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/core/interceptors/api_interceptor.dart';

class DioX {
  DioX._();
  factory DioX() => _internal;
  static final DioX _internal = DioX._();

  Dio _dio(String baseUrl) => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          contentType: ContentType.json.mimeType,
          validateStatus: (status) => status == 200,
        ),
      );

  Dio getDio(String baseUrl) {
    final interceptors = [
      ApiInterceptor(),
      if (!kReleaseMode) LoggingInterceptor(),
      // HTTP Inspector will be not be added if flavor is prod and release mode
      // if (!(kReleaseMode && Config.appFlavor == Flavor.prod))
      //   HttpInspector().alice.getDioInterceptor(),
    ];

    return _dio(baseUrl)..interceptors.addAll(interceptors);
  }
}
