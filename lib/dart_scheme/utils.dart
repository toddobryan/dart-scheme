import "package:collection/collection.dart";

class ImmutableList<T> {
  final List<T> _list;
  final ListEquality<T> _listEq = ListEquality<T>();

  ImmutableList(this._list);

  ImmutableList<T> get reversed => ImmutableList(_list.reversed.toList());

  U fold<U>(U initValue, U Function(U, T) f) => _list.fold(initValue, f);

  @override
  String toString() => "ImmutableList($_list)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ImmutableList<T> &&
              _listEq.equals(_list, other._list);

  @override
  int get hashCode => _list.hashCode;
}