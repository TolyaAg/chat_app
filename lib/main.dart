import 'package:flutter/material.dart';

import 'package:chat_app/screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(),
      home: ChatScreen(),
    );
  }
}
