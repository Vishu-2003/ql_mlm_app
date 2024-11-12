import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/core/services/helpers.dart';
import '/utils/utils.dart';

part 'api_exceptions.dart';

mixin BaseService {
  // i.e. .v1, .v2
  final String apiVersion = '.v1';

  Dio dio = DioX().getDio(baseUrl);

  void setBaseUrl(String baseUrl) {
    dio = DioX().getDio(baseUrl);
  }

  final Map<String, dynamic> requiresToken = {"requiresToken": true};

  Future<T> tryOrCatch<T>(Future<T> Function() methodToRun) async {
    try {
      return await methodToRun();
    } on AppException {
      rethrow;
    } on DioException catch (err) {
      throw getErrorMessageForDioErrors(err);
    } catch (e, trace) {
      debugPrint("$e\n$trace");
      throw AppException(
        "Internal Error occurred, please try again later !",
        "Default Exception: ",
      );
    }
  }
}
