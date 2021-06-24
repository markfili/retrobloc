import 'dart:io';

import 'package:dio/dio.dart';

/// Brings network call result to business logic component.
class ApiResult<T> {
  late final T? data;

  ApiResult({this.data});
}

/// Wraps common exceptions that should be handled by business logic.
///
/// TODO: add callback to properly handle custom errors found in a successful API response (DioErrorType.response)
/// Follow this example to extend error handling: https://dev.to/ashishrawat2911/handling-network-calls-and-exceptions-in-flutter-54me
class ApiError {
  late final dynamic error;

  ApiError({this.error});

  String? get errorMessage {
    if (error != null) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.cancel:
            return "Unstable network connection detected, please reload to try again";
          case DioErrorType.other:
            // error is not known to Dio, extract errors that caused this error and act accordingly
            var originalError = (error as DioError).error;
            if (originalError != null && originalError is SocketException) {
              return "Mothership is not responding, please check your network connection!";
            }
            return "Unknown error occurred, we're trying to fix it!";
          case DioErrorType.response:
            return "Here I would say what's wrong with your request, ex 403, 404, item already exists...";
        }
      }
    }
  }
}
