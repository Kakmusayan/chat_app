import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['username'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 16,
        top: 6,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 42,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.attach_file,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 235,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              margin: const EdgeInsets.all(9),
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration.collapsed(
                    hintText: 'Сообщение',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 42,
            child: InkWell(
              onTap: _submitMessage,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.mic_none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
