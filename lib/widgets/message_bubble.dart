import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        username = null;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String? username;
  final String message;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          // Add some margin to the edges of the messages, to allow space for the
          // user's image.
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            // The side of the chat screen the message should show at.
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // First messages in the sequence provide a visual buffer at
                  // the top.
                  if (isFirstInSequence) const SizedBox(height: 18),

                  // The "speech" box surrounding the message.
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0XFF3CED78)
                          : const Color(0XFFEDF2F6),
                      // Only show the message bubble's "speaking edge" if first in
                      // the chain.
                      // Whether the "speaking edge" is on the left or right depends
                      // on whether or not the message bubble is the current user.
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            !isMe ? Radius.zero : const Radius.circular(16),
                        bottomRight:
                            isMe ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    // Set some reasonable constraints on the width of the
                    // message bubble so it can adjust to the amount of text
                    // it should show.
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 8,
                      right: 16,
                      bottom: 8,
                    ),
                    // Margin around the bubble.
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        // Add a little line spacing to make the text look nicer
                        // when multilined.
                        height: 1.2,
                        color: isMe
                            ? const Color(0xFF00521C)
                            : const Color(0xFF2B333E),
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
