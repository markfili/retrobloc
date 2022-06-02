import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @Named("baseUrl")
  String baseUrl() => "https://60cb5abe21337e0017e448a4.mockapi.io";

  @lazySingleton
  Dio dio(Logger logger, CacheOptions options) {
    var dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: logger.i, // specify log function (optional)
      retries: 3, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));
    dio.interceptors.add(DioCacheInterceptor(options: options));
    return dio;
  }

  @lazySingleton
  CacheOptions options(CacheStore store) {
    return CacheOptions(store: store);
  }

  @lazySingleton
  CacheStore store() {
    return MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
  }
}

@module
abstract class LoggerModule {
  @singleton
  Logger logger() => Logger();
}
