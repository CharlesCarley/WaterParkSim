class Stack<T> {
  final List<T> _stack;
  Stack.zero() : _stack = [];
  Stack.from(List<T> oth) : _stack = oth;

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
      _stack.last;
    }
    return null;
  }
}
