import 'dart:async';

import 'package:flutter/services.dart';

const _methodChannel = MethodChannel('flutterappclips/method');
const _eventChannel = EventChannel('flutterappclips/events');
Stream<String> _stream;

Future<String> getUrl() async {
  final url = await _methodChannel.invokeMethod('getUrl');
  return url;
}

Stream<String> getEventStream() =>
    _stream ??= _eventChannel.receiveBroadcastStream();
