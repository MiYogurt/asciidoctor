import 'dart:async';
import 'config.dart';
import 'type/title.dart';
import 'type/node.dart';


bool isWhiteSpace(String word){
  return word == ' ' || word == ' ';
}

class Parser {
  Config config;
  Parser([this.config]){
    if (this.config == null) {
      this.config = Config();
    }
  }

  bool isToken(String token){
    return ['upperToken', 'titleToken'].map((k) => config.get(k)).contains(token);
  }

  parse(String text) async {
    await for (var line in textLineStream(text)){
      print(parseLine(line));
    }
  }

  ANode parseLine(String line) {
    List<String> words = line.split('');
    return parseTitle(words);
  }

  List<String> parseUpper(List<String> words, List<ANode> child) {
    var start = 0;
    List<String> matchList = [];
    var hasMatched = false;
    var upperToken = config.get('upperToken');
    var isTwoTokenModel = false;
    for (var i = 0; i < words.length; i++) {
      var word = words[i];
      var nextWord;
      try {
       nextWord = words[i+1];
      } catch (_) {}
      matchList.add(word);
      if (word == upperToken && hasMatched == false) {
        start = i;
        if (nextWord == upperToken) {
          isTwoTokenModel = true;
          i+=1;
        }
        hasMatched = true;
        continue;
      }

      if (word == upperToken && hasMatched) {
        if (i == start + 1) {
          continue;
        }

        if (isTwoTokenModel && nextWord !=upperToken) {
          continue;
        }

        var content = matchList.sublist(1, matchList.length - 1);
        var raw = Raw(content.join(), wrap: 'b');
        child.add(raw);
        return isTwoTokenModel ? words.sublist(i + 2) : words.sublist(i + 1);
      }
    }
    return words;
  }

  List<String> parseNormal(List<String> words, List<ANode> child) {
    List<String> matchList = [];
    for(var word in words){
      if (isToken(word)) {
        break;
      }
      matchList.add(word);
    }

    if (matchList.isNotEmpty) {
      child.add(Raw(matchList.join()));
      words = words.sublist(matchList.length);
    }

    return words;
  }
  
  List<ANode> parseInline(List<String> words){
    List<ANode> child = [];
    var upperToken = config.get('upperToken');
    while(words.isNotEmpty){
      if (words[0] == upperToken) {
        words = parseUpper(words, child);
      } else {
        words = parseNormal(words, child);
      }
    }
    return child;
  }

  Title parseTitle(List<String> words){
    var level = 0;
    var titleToken = this.config.get('titleToken');
    var i = 0;
    while (isWhiteSpace(words[i])) {
      i++;
    }

    if (words.isEmpty || words[i] != titleToken) {
      return null;
    }

    do {
      var word = words[i];
      if (word == titleToken) {
        level+=1;
        i+=1;
        continue;
      }

      if (level != 0 && isWhiteSpace(word)) {
        var restWord = words.sublist(i).join().replaceFirst(RegExp(r'^\s?'), '');
        var title = Title(restWord, level: level);
        var child = parseInline(restWord.split(''));
        if (child != null || child.isNotEmpty) {
          title.child = child;
        }
        return title;
      }

    } while (i < words.length);
    return null;
  }

  Stream<String> textLineStream(String text) async* {
    for(var line in text.split(RegExp('\n'))) {
      yield line;
    }
  }
}


var text = '''
== hello

good man

[source,ruby]
----
puts "hello, world"
----
''';

main(List<String> args) {
  var p =Parser();
  p.parse(text);
}