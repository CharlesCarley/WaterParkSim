

import 'dart:async';

class Node
{
  
}


class NodeManager
{
  List<Node> _values = [];
  StreamController<List<Node>> controller = StreamController<List<Node>>();

  void apply(List<Node> evt) async
  {
    _values = evt;
    
  }

  Stream<List<Node>> fetch()  {
    return Stream.value(_values);
  } 
}
