import 'package:asciidoctor/src/type/title.dart';
import 'package:asciidoctor/src/asciidoctor_base.dart';
import 'package:test/test.dart';

void main() {
  Parser parser = Parser();
  group("parse inline", () {
    test("* upper", (){
      var child = parser.parseInline('*good job*'.split(''));
      Raw r = child.first;
      expect(r.wrap, equals('b'));
      expect(r.content, equals('good job'));
      expect(r.html(), contains('good job</b>'));
    });

    test("** upper", (){
      var child = parser.parseInline('**good job2**'.split(''));
      Raw r = child.first;
      expect(r.wrap, equals('b'));
      expect(r.content, equals('good job2'));
      expect(r.html(), contains('good job2</b>'));
    });

    test('text and upper **', () {
      var child = parser.parseInline('good**good job2**'.split(''));
      Raw r1 = child.first;
      expect(r1.wrap, equals(''));
      expect(r1.content, equals('good'));
      expect(r1.html(), contains('good'));

      Raw r2 = child.elementAt(1);
      expect(r2.wrap, equals('b'));
      expect(r2.content, contains('good'));
      expect(r2.html(), contains('good'));
    });

    test('text and upper **', () {
      var child = parser.parseInline('good**good job2**ccc'.split(''));
      Raw r1 = child.first;
      expect(r1.wrap, equals(''));
      expect(r1.content, equals('good'));
      expect(r1.html(), contains('good'));

      Raw r2 = child.elementAt(1);
      expect(r2.wrap, equals('b'));
      expect(r2.content, contains('good'));
      expect(r2.html(), contains('good'));

      Raw r3 = child.elementAt(2);
      expect(r3.wrap, equals(''));
      expect(r3.content, contains('ccc'));
      expect(r3.html(), contains('ccc'));
    });

  });


  group('parse title', () {
    test('title and upper', () {
      var child = parser.parseTitle('== good **man**'.split(''));
      expect(child.html(), equals('<h2>good <b>man</b></h2>'));
    });

  });
}