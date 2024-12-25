import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dependencies.dart';
import 'theme/theme.dart';
import 'widgets/auth_guard.dart';

Future<void> main() async {
  /// Initialize [Flutter] related tasks
  WidgetsFlutterBinding.ensureInitialized();

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Initialize services
  initializeServices();

  /// Initialize date formatting
  await initializeDateFormatting('en');
  await initializeDateFormatting('hr');

  /// Wait for initialization to finish
  await getIt.allReady();

  /// Run [Razgovorko]
  runApp(RazgovorkoApp());
}

class RazgovorkoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (_) => 'Razgovorko',
        home: AuthGuard(),
        theme: RazgovorkoTheme.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('hr'),
        ],
      );
}
