import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('timestamp')
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshot.data.documents;
            return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                final message = chatDocs[index]['text'];
                final userId = chatDocs[index]['userId'];
                final username = chatDocs[index]['username'];
                final isMe = userId == futureSnapshot.data.uid;
                return MessageBubble(
                  username: username,
                  message: message,
                  isMe: isMe,
                  key: ValueKey(chatDocs[index].documentID),
                );
              },
            );
          },
        );
      },
    );
  }
}
