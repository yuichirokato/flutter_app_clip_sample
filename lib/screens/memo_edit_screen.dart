import 'package:flutter/material.dart';
import 'package:flutter_app_clips/models/memo.dart';

class MemoEditScreen extends StatefulWidget {
  final Memo memo;

  MemoEditScreen({@required this.memo});

  @override
  _MemoEditScreenState createState() => _MemoEditScreenState(memo: memo);
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  final Memo memo;

  _MemoEditScreenState({@required this.memo});

  bool _isEditing = false;
  var _textEditingController = TextEditingController();
  Memo _newMemo;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = memo.body;
    _newMemo = memo;
  }

  @override
  Widget build(BuildContext context) {
    final deleteButton = IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {},
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_newMemo.title),
        actions: _isEditing
            ? <Widget>[
                deleteButton,
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: Text(
                    '完了',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ]
            : <Widget>[deleteButton],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints.expand(),
        child: _isEditing
            ? TextField(
                autofocus: true,
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  final newMemo = Memo(title: memo.title, body: value);
                  setState(() {
                    _newMemo = newMemo;
                  });
                },
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: Text(_newMemo.body),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
