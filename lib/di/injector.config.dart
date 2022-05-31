// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i4;

import '../network/api_client.dart' as _i5;
import 'modules.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final loggerModule = _$LoggerModule();
  gh.lazySingleton<_i3.Dio>(() => networkModule.dio());
  gh.singleton<_i4.Logger>(loggerModule.logger());
  gh.factory<String>(() => networkModule.baseUrl(), instanceName: 'baseUrl');
  gh.factory<_i5.ApiClient>(() => _i5.ApiClient(get<_i3.Dio>(),
      baseUrl: get<String>(instanceName: 'baseUrl')));
  return get;
}

class _$NetworkModule extends _i6.NetworkModule {}

class _$LoggerModule extends _i6.LoggerModule {}
