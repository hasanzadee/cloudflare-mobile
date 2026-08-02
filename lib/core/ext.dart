/// Small helpers used across the app.
extension IterableX<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }

  E? firstWhereOrNull(bool Function(E) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
