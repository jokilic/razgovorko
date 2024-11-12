import 'package:get_it/get_it.dart';

import 'services/auth_service.dart';
import 'services/logger_service.dart';
import 'services/supabase_service.dart';
import 'services/user_service.dart';

final getIt = GetIt.instance;

/// Registers a class if it's not already initialized
/// Optionally runs a function with newly registered class
void registerIfNotInitialized<T extends Object>(
  T Function() factoryFunc, {
  String? instanceName,
  void Function(T controller)? afterRegister,
}) {
  if (!getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );

    if (afterRegister != null) {
      final instance = getIt.get<T>(instanceName: instanceName);
      afterRegister(instance);
    }
  }
}

void initializeServices() => getIt
  ..registerSingletonAsync(
    () async => LoggerService(),
  )
  ..registerSingletonAsync(
    () async {
      final supabase = SupabaseService(
        logger: getIt.get<LoggerService>(),
      );
      await supabase.init();
      return supabase;
    },
    dependsOn: [LoggerService],
  )
  ..registerSingletonAsync(
    () async => AuthService(
      logger: getIt.get<LoggerService>(),
    ),
    dependsOn: [LoggerService],
  )
  ..registerSingletonAsync(
    () async => UserService(
      logger: getIt.get<LoggerService>(),
    ),
    dependsOn: [LoggerService],
  );
