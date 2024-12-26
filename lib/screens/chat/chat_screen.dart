import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../constants/images.dart';
import '../../dependencies.dart';
import '../../services/auth_service.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/users_table_service.dart';
import '../../theme/theme.dart';
import '../../widgets/razgovorko_button.dart';
import '../onboarding/widgets/onboarding_button.dart';
import 'chat_controller.dart';
import 'chat_users_controller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ConfettiController confettiController;

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<ChatUsersController>(
      () => ChatUsersController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
    );
    registerIfNotInitialized<ChatController>(
      () => ChatController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
        messagesTable: getIt.get<MessagesTableService>(),
      ),
    );

    confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    )..play();
  }

  @override
  void dispose() {
    getIt
      ..unregister<ChatUsersController>()
      ..unregister<ChatController>();

    confettiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersController = getIt.get<ChatUsersController>();

    final topSpacing = MediaQuery.paddingOf(context).top;
    final bottomSpacing = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          ///
          /// CONTENT
          ///
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              /// BACK
              ///
              IgnorePointer(
                child: Opacity(
                  opacity: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: topSpacing + 16, left: 16),
                    child: RazgovorkoButton(
                      onPressed: Navigator.of(context).pop,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 36,
                        color: context.colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              ///
              /// HEADER IMAGE
              ///
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, bottomSpacing),
                  child: Center(
                    child: Image.asset(
                      RazgovorkoImages.illustration3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Successfully logged in',
                      style: context.textStyles.onboardingTitle,
                    ),
                    const SizedBox(height: 6),
                    StreamBuilder(
                      stream: usersController.streamCurrentUser(),
                      builder: (context, userSnapshot) {
                        final user = userSnapshot.data;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${user?.displayName}',
                              style: context.textStyles.onboardingText,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Number: ${user?.internationalPhoneNumber}',
                              style: context.textStyles.onboardingText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 72),
                    OnboardingButton(
                      buttonText: 'Sign out',
                      isActive: true,
                      onPressed: usersController.signOut,
                    ),
                    SizedBox(height: bottomSpacing + 48),
                  ],
                ),
              ),

              // Expanded(
              //   child: StreamBuilder(
              //     stream: usersController.streamAllUsers(),
              //     builder: (context, usersSnapshot) {
              //       ///
              //       /// LOADING
              //       ///
              //       if (usersSnapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }

              //       ///
              //       /// ERROR
              //       ///
              //       if (usersSnapshot.hasError) {
              //         return Text(
              //           usersSnapshot.error.toString(),
              //         );
              //       }

              //       ///
              //       /// SUCCESS
              //       ///
              //       if (usersSnapshot.hasData) {
              //         final users = usersSnapshot.data;

              //         return ListView.builder(
              //           itemCount: users?.length ?? 0,
              //           physics: const BouncingScrollPhysics(),
              //           itemBuilder: (_, index) {
              //             final user = users![index];

              //             return ListTile(
              //               onTap: () => openConversation(
              //                 context,
              //                 otherUsers: users,
              //                 chatName: 'Our chat',
              //                 chatType: ChatType.group,
              //               ),
              //               title: Text(
              //                 user.displayName,
              //                 style: const TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               subtitle: Text(user.email),
              //               leading: const CircleAvatar(
              //                 radius: 24,
              //                 backgroundColor: Colors.deepPurple,
              //                 child: Icon(
              //                   Icons.person_rounded,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //             );
              //           },
              //         );
              //       }

              //       return const Text(
              //         "This shouldn't happen",
              //       );
              //     },
              //   ),
              // ),
            ],
          ),

          ///
          /// CONFETTI
          ///
          Align(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.2,
              numberOfParticles: 15,
              shouldLoop: true,
              colors: [
                context.colors.cyan,
                context.colors.black,
                context.colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
