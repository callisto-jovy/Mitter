///Taken from: Alex Ritt (https://stackoverflow.com/questions/73214483/how-to-extend-dart-sockets-broadcaststream-buffer-size-of-1024-bytes)
///(Thank you so much, this is the generic approach)
/// This was created since the native [reduce] says:
/// > When this stream is done, the returned future is completed with the value at that time.
///
/// The problem is that socket connections does not emits the [done] event after
/// each message but after the socket disconnection.
///
/// So here is a implementation that combines [reduce] and [takeWhile].
extension ReduceWhile<T> on Stream<T> {
  Future<T> reduceWhile({
    required T Function(T previous, T element) combine,
    required bool Function(T) combineWhile,
    T? initialValue,
  }) async {
    T initial = initialValue ?? await first;

    await for (T element in this) {
      initial = combine(initial, element);
      if (!combineWhile(initial)) break;
    }

    return initial;
  }
}

extension SplitInto<T> on List<T> {
  Iterable<List<T>> split(bool Function(T element) test) sync* {
    if (isEmpty) return;
    int start = 0;
    for (int i = 0; i < length; i++) {
      T element = this[i];

      if (test(element) && start < i) {
        yield sublist(start, i);
        start = i;
      }
    }
    if (start < length) {
      yield sublist(start);
    }
  }
}

extension ToMap<T> on Iterable<T> {
  Map<String, E> toMap<E>(String Function(T key) key, E Function(T value) value) {
    Map<String, E> map = {};
    for (T element in this) {
      map[key(element)] = value(element);
    }
    return map;
  }
}
