class ListStack<T> {
  final List<T> _stack;
  ListStack.zero() : _stack = [];
  ListStack.from(List<T> oth) : _stack = oth;

  get isEmpty => _stack.isEmpty;
  get isNotEmpty => _stack.isNotEmpty;

  void push(T elm) {
    _stack.add(elm);
  }

  void pop() {
    if (_stack.isNotEmpty) {
      _stack.removeLast();
    }
  }

  T? peek(int offset) {
    int loc = _stack.length - offset;
    if (loc >= 0) {
      _stack[loc];
    }
    return null;
  }

  T? top() {
    if (_stack.isNotEmpty) {
      return _stack.last;
    }
    return null;
  }

  void clear() {
    _stack.clear();
  }
}
