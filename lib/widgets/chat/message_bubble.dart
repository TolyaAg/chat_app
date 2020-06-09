import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;

  const MessageBubble({
    this.message,
    this.isMe,
    this.key,
    this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  isMe ? const Radius.circular(12) : const Radius.circular(0),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).accentTextTheme.bodyText1.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
