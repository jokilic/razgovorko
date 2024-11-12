import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../util/env.dart';
import 'logger_service.dart';

final supabase = Supabase.instance.client;

class SupabaseService {
  final LoggerService logger;

  SupabaseService({
    required this.logger,
  });

  ///
  /// METHODS
  ///

  /// Initializes [Supabase]
  Future<bool> init() async {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        debug: kDebugMode,
      );

      logger.t('SupabaseService -> init() -> success!');
      return true;
    } catch (e) {
      logger.e('SupabaseService -> init() -> $e');
      return false;
    }
  }
}
