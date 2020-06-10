import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final _messageNotifier = ValueNotifier<String>('');
  final _controller = TextEditingController();

  Future<void> _sendMessage(BuildContext ctx) async {
    // FocusScope.of(ctx).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _messageNotifier.value,
      'timestamp': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();
    _messageNotifier.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              onChanged: (value) {
                _messageNotifier.value = value;
              },
              controller: _controller,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _messageNotifier,
            builder: (_, String value, __) {
              return IconButton(
                color: Theme.of(context).primaryColor,
                icon: const Icon(Icons.send),
                onPressed:
                    value.trim().isEmpty ? null : () => _sendMessage(context),
              );
            },
          ),
        ],
      ),
    );
  }
}
