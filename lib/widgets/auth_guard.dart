import 'package:flutter/material.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/login/login_screen.dart';
import '../services/supabase_service.dart';

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: supabase.auth.onAuthStateChange,
          builder: (context, authStateSnapshot) {
            ///
            /// LOADING
            ///
            if (authStateSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.grey,
              );
            }

            ///
            /// ERROR
            ///
            if (authStateSnapshot.hasError) {
              return Container(
                color: Colors.red,
              );
            }

            ///
            /// SUCCESS
            ///
            if (authStateSnapshot.hasData) {
              ///
              /// LOGGED IN
              ///
              if (authStateSnapshot.data?.session?.user != null) {
                return ChatScreen();
              }

              ///
              /// NOT LOGGED IN
              ///
              else {
                return LoginScreen();
              }
            }

            return Container(
              color: Colors.blue,
            );
          },
        ),
      );
}
