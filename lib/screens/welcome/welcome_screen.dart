import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';
import 'welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<WelcomeController>(
      () => WelcomeController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<WelcomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<WelcomeController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ///
            /// HEADER IMAGE
            ///
            const Expanded(
              child: Placeholder(),
            ),

            ///
            /// CONTENT
            ///
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What is your name?'),
                  TextField(
                    controller: controller.nameController,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final supabaseUser = await controller.signUp(
                        email: controller.nameController.text.trim(),
                        password: controller.passwordController.text.trim(),
                      );

                      if (supabaseUser != null) {
                        await controller.createUser(
                          supabaseUser: supabaseUser,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    label: Text('Signup'.toUpperCase()),
                    icon: const Icon(
                      Icons.app_registration_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
