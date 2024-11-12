import 'package:flutter/material.dart';

import 'screens/login/login_screen.dart';
import 'util/navigation.dart';

/// Opens [LoginScreen]
void openLogin(BuildContext context) => pushScreen(
      LoginScreen(),
      context: context,
    );
