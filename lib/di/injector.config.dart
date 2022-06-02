// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i5;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i4;

import '../network/api_client.dart' as _i6;
import 'modules.dart' as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final loggerModule = _$LoggerModule();
  gh.lazySingleton<_i3.CacheStore>(() => networkModule.store());
  gh.singleton<_i4.Logger>(loggerModule.logger());
  gh.factory<String>(() => networkModule.baseUrl(), instanceName: 'baseUrl');
  gh.lazySingleton<_i3.CacheOptions>(
      () => networkModule.options(get<_i3.CacheStore>()));
  gh.lazySingleton<_i5.Dio>(
      () => networkModule.dio(get<_i4.Logger>(), get<_i3.CacheOptions>()));
  gh.factory<_i6.ApiClient>(() => _i6.ApiClient(get<_i5.Dio>(),
      baseUrl: get<String>(instanceName: 'baseUrl')));
  return get;
}

class _$NetworkModule extends _i7.NetworkModule {}

class _$LoggerModule extends _i7.LoggerModule {}
