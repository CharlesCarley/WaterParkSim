class EventDispatcher<T> {
  List<T> receivers = <T>[];

  void subscribe(T receiver) {
    if (!receivers.contains(receiver)) {
      receivers.add(receiver);
    }
  }

  void unsubscribe(T receiver) {
    if (receivers.contains(receiver)) {
      receivers.remove(receiver);
    }
  }
}
