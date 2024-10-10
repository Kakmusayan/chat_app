import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/message_bubble.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Чаты"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Нет сообщений!'),
                );
              }

              if (chatSnapshot.hasError) {
                return const Center(
                  child: Text('Пройзошел сбой!'),
                );
              }

              final loadedMessages = chatSnapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 38),
                reverse: true,
                shrinkWrap: true,
                itemCount: loadedMessages.length,
                itemBuilder: (ctx, index) {
                  final chatMessage = loadedMessages[index].data();
                  final nextChatMessage = index + 1 < loadedMessages.length
                      ? loadedMessages[index + 1].data()
                      : null;
                  final currentMessageUserId = chatMessage['userId'];
                  final nextMessageUserId = nextChatMessage != null
                      ? nextChatMessage['userId']
                      : null;
                  final nextUserIdSame =
                      nextMessageUserId == currentMessageUserId;

                  if (nextUserIdSame) {
                    return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageUserId,
                    );
                  } else {
                    return MessageBubble.first(
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageUserId,
                    );
                  }
                },
              );
            },
          );

          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0XFF1FDB5F),
              radius: 16,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(userInfo.lastName != null
                      ? userInfo.lastName![0]
                      : 'NULL'),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
