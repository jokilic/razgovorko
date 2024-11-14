import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../dependencies.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../util/state.dart';
import 'conversation_controller.dart';

class ConversationScreen extends WatchingStatefulWidget {
  final RazgovorkoUser otherUser;

  const ConversationScreen({
    required this.otherUser,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<ConversationController>(
      () => ConversationController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        messagesTable: getIt.get<MessagesTableService>(),
      ),
      afterRegister: (controller) => controller.init(
        otherUserIds: [widget.otherUser.id],
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<ConversationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = watchIt<ConversationController>().value;
    // final controller = getIt.get<ConversationController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: switch (conversationState) {
            Initial() => Container(
                color: Colors.grey,
              ),
            Loading() => Container(
                color: Colors.yellow,
              ),
            Empty() => Container(
                color: Colors.cyan,
              ),
            Error(error: final error) => Container(
                color: Colors.red,
                child: Text(error ?? 'no_error'),
              ),
            Success(data: final data) => Container(
                color: Colors.green,
                child: Text(data),
              ),
          },
        ),
      ),
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 40,
    //         vertical: 24,
    //       ),
    //       child: StreamBuilder(
    //         stream: controller.streamAllUsers(),
    //         builder: (context, usersSnapshot) {
    //           ///
    //           /// LOADING
    //           ///
    //           if (usersSnapshot.connectionState == ConnectionState.waiting) {
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }

    //           ///
    //           /// ERROR
    //           ///
    //           if (usersSnapshot.hasError) {
    //             return Text(
    //               usersSnapshot.error.toString(),
    //             );
    //           }

    //           ///
    //           /// SUCCESS
    //           ///
    //           if (usersSnapshot.hasData) {
    //             final users = usersSnapshot.data;

    //             return ListView.builder(
    //               itemCount: users?.length ?? 0,
    //               physics: const BouncingScrollPhysics(),
    //               itemBuilder: (_, index) {
    //                 final user = users![index];

    //                 return ListTile(
    //                   onTap: () {},
    //                   title: Text(
    //                     user.email ?? user.displayName,
    //                   ),
    //                 );
    //               },
    //             );
    //           }

    //           return Text(
    //             usersSnapshot.error.toString(),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
