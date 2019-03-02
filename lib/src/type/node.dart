class ANode {
  String type = '';
  List<ANode> child = [];

  String html(){
    if (child.isNotEmpty) {
      return child.map((c) => c.html()).join();
    }
    return '';
  }
}