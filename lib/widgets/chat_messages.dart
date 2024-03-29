import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Text(
              loadedMessages[index].data()['text'],
            );
          },
        );
      },
    );
  }
}
