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
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Razgovorko',
                    style: TextStyle(
                      fontFamily: 'AguDisplay',
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Razgovorko will help you chat with people.',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'What is your name?',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextField(
                    controller: controller.nameController,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final supabaseUser = await controller.signUpWithEmail(
                        email: 'mail@gmail.com',
                        password: 'hellothere',
                      );

                      if (supabaseUser != null) {
                        await controller.createUser(
                          supabaseUser: supabaseUser,
                          internationalPhoneNumber: '',
                          nationalPhoneNumber: '',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    label: Text('R neksuses'.toUpperCase()),
                    icon: const Icon(
                      Icons.person_rounded,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async => controller.signIn(
                      email: 'neksuses@gmail.com',
                      password: 'helloneksus',
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    label: Text('L neksuses'.toUpperCase()),
                    icon: const Icon(
                      Icons.login_rounded,
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
