import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LoginController>(
      () => LoginController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<LoginController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => controller.signIn(
                    email: controller.emailController.text.trim(),
                    password: controller.passwordController.text.trim(),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      48,
                    ),
                  ),
                  label: Text('Login'.toUpperCase()),
                  icon: const Icon(
                    Icons.login_rounded,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    final supabaseUser = await controller.signUp(
                      email: controller.emailController.text.trim(),
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
        ),
      ),
    );
  }
}
