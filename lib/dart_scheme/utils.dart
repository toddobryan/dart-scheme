// TODO: have this class use an int while possible, but switch to BigInt when necessary
class FlexInt with Compare<FlexInt> {
  final BigInt value;

  FlexInt._(this.value);

  factory FlexInt.fromInt(int v) => FlexInt._(BigInt.from(v));
  factory FlexInt.fromBigInt(BigInt v) => FlexInt._(v);

  static FlexInt zero = FlexInt.fromBigInt(BigInt.zero);
  static FlexInt one = FlexInt.fromBigInt(BigInt.one);
  static FlexInt two = FlexInt.fromBigInt(BigInt.two);
  static FlexInt maxByte = FlexInt.fromInt(255);

  double toDouble() => value.toDouble();

  @override
  int compareTo(FlexInt other) => value.compareTo(other.value);

  FlexInt gcd(FlexInt other) => FlexInt.fromBigInt(value.gcd(other.value));

  FlexInt operator ~/(FlexInt other) => FlexInt.fromBigInt(value ~/ other.value);
  double operator /(FlexInt other) => value / other.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlexInt &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

mixin Compare<T> implements Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator <(T other) => compareTo(other) < 0;
  bool operator >(T other) => compareTo(other) > 0;
  bool operator >=(T other) => compareTo(other) >= 0;
}