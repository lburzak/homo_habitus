extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) toElement) {
    var index = 0;
    return map((item) => toElement(item, index++));
  }
}