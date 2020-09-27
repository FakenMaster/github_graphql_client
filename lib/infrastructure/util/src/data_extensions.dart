extension StringX on String {}

extension ListX<T> on List<T> {
  bool get notEmpty {
    return this != null && this.isNotEmpty;
  }
}
