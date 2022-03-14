import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_slide_puzzle/injector.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() {
  $initGetIt(getIt);
}
