import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String avatar;

  const MessageBubble({
    this.message,
    this.isMe,
    this.key,
    this.username,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe) UserAvatar(avatar: avatar, username: username, isMe: isMe),
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
            // horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
        if (isMe) UserAvatar(avatar: avatar, username: username, isMe: isMe),
      ],
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.avatar,
    @required this.username,
    @required this.isMe,
  }) : super(key: key);

  final String avatar;
  final String username;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: CircleAvatar(
        child: avatar == null
            ? Text(
                username[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        backgroundImage: avatar != null ? NetworkImage(avatar) : null,
        backgroundColor: isMe
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
      ),
    );
  }
}
