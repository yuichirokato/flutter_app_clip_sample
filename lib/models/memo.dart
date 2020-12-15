class Memo {
  final String title;
  final String body;

  String get caption => (title == null || title.isEmpty) ? body : title;

  const Memo({this.title, this.body});
}
