import 'package:flutter/material.dart';
import 'package:flutter_app_clips/models/memo.dart';
import 'package:flutter_app_clips/screens/memo_edit_screen.dart';

class MemoListScreen extends StatefulWidget {
  @override
  _MemoListScreenState createState() => _MemoListScreenState();
}

class _MemoListScreenState extends State<MemoListScreen> {
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    memos = _buildDummyMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Memo list')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: memos.length,
          itemBuilder: (context, index) {
            final memo = memos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoEditScreen(memo: memo),
                  ),
                );
              },
              child: Container(
                child: Text(
                  memo.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                padding: EdgeInsets.only(top: 8),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  List<Memo> _buildDummyMemo() {
    return [
      Memo(title: '買い物リスト', body: '- 牛乳\n- 卵\n- ちくわ'),
      Memo(title: '買い物リスト', body: '- 牛乳\n- 卵\n- ちくわ'),
      Memo(title: '', body: '- 牛乳\n- 卵\n- ちくわ'),
      Memo(body: '- 牛乳\n- 卵\n- ちくわ'),
    ];
  }
}
