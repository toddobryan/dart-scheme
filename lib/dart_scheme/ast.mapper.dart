// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ast.dart';

class SExprMapper extends ClassMapperBase<SExpr> {
  SExprMapper._();

  static SExprMapper? _instance;
  static SExprMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SExprMapper._());
      AtomMapper.ensureInitialized();
      PairMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SExpr';
  @override
  Function get typeFactory =>
      <T>(f) => f<SExpr<T>>();

  static Token<dynamic>? _$token(SExpr v) => v.token;
  static dynamic _arg$token<T>(f) => f<Token<T>>();
  static const Field<SExpr, Token<dynamic>> _f$token = Field(
    'token',
    _$token,
    arg: _arg$token,
  );
  static SExprType _$type(SExpr v) => v.type;
  static const Field<SExpr, SExprType> _f$type = Field('type', _$type);

  @override
  final MappableFields<SExpr> fields = const {#token: _f$token, #type: _f$type};

  static SExpr<T> _instantiate<T>(DecodingData data) {
    throw MapperException.missingConstructor('SExpr');
  }

  @override
  final Function instantiate = _instantiate;

  static SExpr<T> fromMap<T>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SExpr<T>>(map);
  }

  static SExpr<T> fromJson<T>(String json) {
    return ensureInitialized().decodeJson<SExpr<T>>(json);
  }
}

mixin SExprMappable<T> {
  String toJson();
  Map<String, dynamic> toMap();
  SExprCopyWith<SExpr<T>, SExpr<T>, SExpr<T>, T> get copyWith;
}

abstract class SExprCopyWith<$R, $In extends SExpr<T>, $Out, T>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SExprCopyWith<$R2, $In, $Out2, T> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class AtomMapper extends ClassMapperBase<Atom> {
  AtomMapper._();

  static AtomMapper? _instance;
  static AtomMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AtomMapper._());
      SExprMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Atom';
  @override
  Function get typeFactory =>
      <T>(f) => f<Atom<T>>();

  static Token<dynamic>? _$token(Atom v) => v.token;
  static dynamic _arg$token<T>(f) => f<Token<T>>();
  static const Field<Atom, Token<dynamic>> _f$token = Field(
    'token',
    _$token,
    arg: _arg$token,
  );
  static SExprType _$type(Atom v) => v.type;
  static const Field<Atom, SExprType> _f$type = Field('type', _$type);

  @override
  final MappableFields<Atom> fields = const {#token: _f$token, #type: _f$type};

  static Atom<T> _instantiate<T>(DecodingData data) {
    return Atom(data.dec(_f$token), data.dec(_f$type));
  }

  @override
  final Function instantiate = _instantiate;

  static Atom<T> fromMap<T>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Atom<T>>(map);
  }

  static Atom<T> fromJson<T>(String json) {
    return ensureInitialized().decodeJson<Atom<T>>(json);
  }
}

mixin AtomMappable<T> {
  String toJson() {
    return AtomMapper.ensureInitialized().encodeJson<Atom<T>>(this as Atom<T>);
  }

  Map<String, dynamic> toMap() {
    return AtomMapper.ensureInitialized().encodeMap<Atom<T>>(this as Atom<T>);
  }

  AtomCopyWith<Atom<T>, Atom<T>, Atom<T>, T> get copyWith =>
      _AtomCopyWithImpl<Atom<T>, Atom<T>, T>(
        this as Atom<T>,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AtomMapper.ensureInitialized().stringifyValue(this as Atom<T>);
  }

  @override
  bool operator ==(Object other) {
    return AtomMapper.ensureInitialized().equalsValue(this as Atom<T>, other);
  }

  @override
  int get hashCode {
    return AtomMapper.ensureInitialized().hashValue(this as Atom<T>);
  }
}

extension AtomValueCopy<$R, $Out, T> on ObjectCopyWith<$R, Atom<T>, $Out> {
  AtomCopyWith<$R, Atom<T>, $Out, T> get $asAtom =>
      $base.as((v, t, t2) => _AtomCopyWithImpl<$R, $Out, T>(v, t, t2));
}

abstract class AtomCopyWith<$R, $In extends Atom<T>, $Out, T>
    implements SExprCopyWith<$R, $In, $Out, T> {
  @override
  $R call({Token<T>? token, SExprType? type});
  AtomCopyWith<$R2, $In, $Out2, T> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AtomCopyWithImpl<$R, $Out, T>
    extends ClassCopyWithBase<$R, Atom<T>, $Out>
    implements AtomCopyWith<$R, Atom<T>, $Out, T> {
  _AtomCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Atom> $mapper = AtomMapper.ensureInitialized();
  @override
  $R call({Object? token = $none, SExprType? type}) => $apply(
    FieldCopyWithData({
      if (token != $none) #token: token,
      if (type != null) #type: type,
    }),
  );
  @override
  Atom<T> $make(CopyWithData data) => Atom(
    data.get(#token, or: $value.token),
    data.get(#type, or: $value.type),
  );

  @override
  AtomCopyWith<$R2, Atom<T>, $Out2, T> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AtomCopyWithImpl<$R2, $Out2, T>($value, $cast, t);
}

class PairMapper extends ClassMapperBase<Pair> {
  PairMapper._();

  static PairMapper? _instance;
  static PairMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PairMapper._());
      SExprMapper.ensureInitialized();
      SExprMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Pair';
  @override
  Function get typeFactory =>
      <T1, T2>(f) => f<Pair<T1, T2>>();

  static SExpr<dynamic> _$car(Pair v) => v.car;
  static dynamic _arg$car<T1, T2>(f) => f<SExpr<T1>>();
  static const Field<Pair, SExpr<dynamic>> _f$car = Field(
    'car',
    _$car,
    arg: _arg$car,
  );
  static SExpr<dynamic> _$cdr(Pair v) => v.cdr;
  static dynamic _arg$cdr<T1, T2>(f) => f<SExpr<T2>>();
  static const Field<Pair, SExpr<dynamic>> _f$cdr = Field(
    'cdr',
    _$cdr,
    arg: _arg$cdr,
  );
  static Token<(dynamic, dynamic)>? _$token(Pair v) => v.token;
  static dynamic _arg$token<T1, T2>(f) => f<Token<(T1, T2)>>();
  static const Field<Pair, Token<(dynamic, dynamic)>> _f$token = Field(
    'token',
    _$token,
    mode: FieldMode.member,
    arg: _arg$token,
  );
  static SExprType _$type(Pair v) => v.type;
  static const Field<Pair, SExprType> _f$type = Field(
    'type',
    _$type,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Pair> fields = const {
    #car: _f$car,
    #cdr: _f$cdr,
    #token: _f$token,
    #type: _f$type,
  };

  static Pair<T1, T2> _instantiate<T1, T2>(DecodingData data) {
    return Pair(data.dec(_f$car), data.dec(_f$cdr));
  }

  @override
  final Function instantiate = _instantiate;

  static Pair<T1, T2> fromMap<T1, T2>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Pair<T1, T2>>(map);
  }

  static Pair<T1, T2> fromJson<T1, T2>(String json) {
    return ensureInitialized().decodeJson<Pair<T1, T2>>(json);
  }
}

mixin PairMappable<T1, T2> {
  String toJson() {
    return PairMapper.ensureInitialized().encodeJson<Pair<T1, T2>>(
      this as Pair<T1, T2>,
    );
  }

  Map<String, dynamic> toMap() {
    return PairMapper.ensureInitialized().encodeMap<Pair<T1, T2>>(
      this as Pair<T1, T2>,
    );
  }

  PairCopyWith<Pair<T1, T2>, Pair<T1, T2>, Pair<T1, T2>, T1, T2> get copyWith =>
      _PairCopyWithImpl<Pair<T1, T2>, Pair<T1, T2>, T1, T2>(
        this as Pair<T1, T2>,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PairMapper.ensureInitialized().stringifyValue(this as Pair<T1, T2>);
  }

  @override
  bool operator ==(Object other) {
    return PairMapper.ensureInitialized().equalsValue(
      this as Pair<T1, T2>,
      other,
    );
  }

  @override
  int get hashCode {
    return PairMapper.ensureInitialized().hashValue(this as Pair<T1, T2>);
  }
}

extension PairValueCopy<$R, $Out, T1, T2>
    on ObjectCopyWith<$R, Pair<T1, T2>, $Out> {
  PairCopyWith<$R, Pair<T1, T2>, $Out, T1, T2> get $asPair =>
      $base.as((v, t, t2) => _PairCopyWithImpl<$R, $Out, T1, T2>(v, t, t2));
}

abstract class PairCopyWith<$R, $In extends Pair<T1, T2>, $Out, T1, T2>
    implements SExprCopyWith<$R, $In, $Out, (T1, T2)> {
  SExprCopyWith<$R, SExpr<T1>, SExpr<T1>, T1> get car;
  SExprCopyWith<$R, SExpr<T2>, SExpr<T2>, T2> get cdr;
  @override
  $R call({SExpr<T1>? car, SExpr<T2>? cdr});
  PairCopyWith<$R2, $In, $Out2, T1, T2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PairCopyWithImpl<$R, $Out, T1, T2>
    extends ClassCopyWithBase<$R, Pair<T1, T2>, $Out>
    implements PairCopyWith<$R, Pair<T1, T2>, $Out, T1, T2> {
  _PairCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Pair> $mapper = PairMapper.ensureInitialized();
  @override
  SExprCopyWith<$R, SExpr<T1>, SExpr<T1>, T1> get car =>
      $value.car.copyWith.$chain((v) => call(car: v));
  @override
  SExprCopyWith<$R, SExpr<T2>, SExpr<T2>, T2> get cdr =>
      $value.cdr.copyWith.$chain((v) => call(cdr: v));
  @override
  $R call({SExpr<T1>? car, SExpr<T2>? cdr}) => $apply(
    FieldCopyWithData({if (car != null) #car: car, if (cdr != null) #cdr: cdr}),
  );
  @override
  Pair<T1, T2> $make(CopyWithData data) =>
      Pair(data.get(#car, or: $value.car), data.get(#cdr, or: $value.cdr));

  @override
  PairCopyWith<$R2, Pair<T1, T2>, $Out2, T1, T2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PairCopyWithImpl<$R2, $Out2, T1, T2>($value, $cast, t);
}

