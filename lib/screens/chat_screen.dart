import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/pelBYvwsiJkZgTkXEG7g/messages')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic> messages = snapshot.data.documents;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (ctx, i) {
              final message = messages[i];
              return Container(
                padding: EdgeInsets.all(8),
                child: Text(message['text']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/pelBYvwsiJkZgTkXEG7g/messages')
              .add({'text': 'Third message!'});
        },
      ),
    );
  }
}
