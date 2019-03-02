import 'package:asciidoctor/src/type/title.dart';
import 'package:test/test.dart';

void main() {
  group("title", () {
    test("output h1", (){
      var h1 =Title('hello world');
      expect(h1.html(), equals('<h1>hello world</h1>'));
    });

    test("output b", (){
      var raw = Raw('hello world', wrap: 'b');
      expect(raw.html(), equals('<b>hello world</b>'));
    });
  });
}