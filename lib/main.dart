import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_clips/models/experience_handler.dart';
import 'package:flutter_app_clips/models/memo.dart';
import 'package:flutter_app_clips/screens/loading_screen.dart';
import 'package:flutter_app_clips/screens/memo_edit_screen.dart';
import 'package:flutter_app_clips/screens/memo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _enableEventReceiver();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoadingScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => MemoListScreen(),
        '/edit': (context) {
          final memo = Memo(title: '買い物リスト', body: '- 牛乳\n- 卵\n- ちくわ');
          return MemoEditScreen(memo: memo);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  void _enableEventReceiver() {
    _streamSubscription = getEventStream().listen((event) {
      Navigator.pushReplacementNamed(context, '/edit');
    }, onError: (error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  void _disableEventReceiver() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }
}
