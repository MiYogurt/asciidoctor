import 'node.dart';

class Raw extends ANode{
  String content;
  String wrap;
  Raw(this.content, {this.wrap = ''});
  String html() {
    if (this.wrap != '') {
      return '<$wrap>$content</$wrap>';
    }
    return content;
  }
}

class Title extends ANode{
  num level;
  Title(String text, {this.level = 1}) {
    this.child = [Raw(text)];
  }

  @override
  String html() {
    return '<h$level>${super.html()}</h$level>';
  }
}