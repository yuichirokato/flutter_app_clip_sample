import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_clips/models/memo.dart';
import 'package:flutter_app_clips/screens/memo_edit_screen.dart';
import 'package:flutter_app_clips/screens/memo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MemoListScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => MemoListScreen(),
        '/edit': (context) {
          final memo = Memo(title: '買い物リスト', body: '- 牛乳\n- 卵\n- ちくわ');
          return MemoEditScreen(memo: memo);
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _eventChannel =
      const EventChannel('flutterappclips/launchevents');
  StreamSubscription _streamSubscription;
  String _platformMessage;

  @override
  void initState() {
    super.initState();
    _enableEventReceiver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter with app clip sample'),
      ),
      body: Container(
        child: Center(
          child: Text(_platformMessage ?? 'initial message!'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  void _enableEventReceiver() {
    _streamSubscription =
        _eventChannel.receiveBroadcastStream().listen((event) {
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
