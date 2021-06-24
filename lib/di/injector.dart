import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

var getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);