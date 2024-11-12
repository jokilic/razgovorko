import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dependencies.dart';
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
      );
}
