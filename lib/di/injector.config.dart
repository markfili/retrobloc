// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i7;

import '../blocs/articles/articles_bloc.dart' as _i6;
import '../network/api_client.dart' as _i4;
import '../network/repositories/articles/articles_repository.dart' as _i5;
import 'modules.dart' as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final loggerModule = _$LoggerModule();
  gh.lazySingleton<_i3.Dio>(() => networkModule.dio());
  gh.factory<String>(() => networkModule.baseUrl(), instanceName: 'baseUrl');
  gh.factory<_i4.ApiClient>(() => _i4.ApiClient(get<_i3.Dio>(),
      baseUrl: get<String>(instanceName: 'baseUrl')));
  gh.factory<_i5.ArticlesRepository>(
      () => _i5.ArticlesRepository(get<_i4.ApiClient>()));
  gh.factory<_i6.ArticlesBloc>(() => _i6.ArticlesBloc(get<_i7.Logger>(),
      repository: get<_i5.ArticlesRepository>()));
  gh.singleton<_i7.Logger>(loggerModule.logger());
  return get;
}

class _$NetworkModule extends _i8.NetworkModule {}

class _$LoggerModule extends _i8.LoggerModule {}
