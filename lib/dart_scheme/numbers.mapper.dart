// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'numbers.dart';

class SExactRationalMapper extends ClassMapperBase<SExactRational> {
  SExactRationalMapper._();

  static SExactRationalMapper? _instance;
  static SExactRationalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SExactRationalMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SExactRational';

  static Radix _$radix(SExactRational v) => v.radix;
  static const Field<SExactRational, Radix> _f$radix = Field('radix', _$radix);
  static BigInt _$numerator(SExactRational v) => v.numerator;
  static const Field<SExactRational, BigInt> _f$numerator = Field(
    'numerator',
    _$numerator,
  );
  static BigInt _$denominator(SExactRational v) => v.denominator;
  static const Field<SExactRational, BigInt> _f$denominator = Field(
    'denominator',
    _$denominator,
  );

  @override
  final MappableFields<SExactRational> fields = const {
    #radix: _f$radix,
    #numerator: _f$numerator,
    #denominator: _f$denominator,
  };

  static SExactRational _instantiate(DecodingData data) {
    return SExactRational(
      data.dec(_f$radix),
      data.dec(_f$numerator),
      data.dec(_f$denominator),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SExactRational fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SExactRational>(map);
  }

  static SExactRational fromJson(String json) {
    return ensureInitialized().decodeJson<SExactRational>(json);
  }
}

mixin SExactRationalMappable {
  String toJson() {
    return SExactRationalMapper.ensureInitialized().encodeJson<SExactRational>(
      this as SExactRational,
    );
  }

  Map<String, dynamic> toMap() {
    return SExactRationalMapper.ensureInitialized().encodeMap<SExactRational>(
      this as SExactRational,
    );
  }

  SExactRationalCopyWith<SExactRational, SExactRational, SExactRational>
  get copyWith => _SExactRationalCopyWithImpl<SExactRational, SExactRational>(
    this as SExactRational,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SExactRationalMapper.ensureInitialized().stringifyValue(
      this as SExactRational,
    );
  }

  @override
  bool operator ==(Object other) {
    return SExactRationalMapper.ensureInitialized().equalsValue(
      this as SExactRational,
      other,
    );
  }

  @override
  int get hashCode {
    return SExactRationalMapper.ensureInitialized().hashValue(
      this as SExactRational,
    );
  }
}

extension SExactRationalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SExactRational, $Out> {
  SExactRationalCopyWith<$R, SExactRational, $Out> get $asSExactRational =>
      $base.as((v, t, t2) => _SExactRationalCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SExactRationalCopyWith<$R, $In extends SExactRational, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Radix? radix, BigInt? numerator, BigInt? denominator});
  SExactRationalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SExactRationalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SExactRational, $Out>
    implements SExactRationalCopyWith<$R, SExactRational, $Out> {
  _SExactRationalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SExactRational> $mapper =
      SExactRationalMapper.ensureInitialized();
  @override
  $R call({Radix? radix, BigInt? numerator, BigInt? denominator}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (numerator != null) #numerator: numerator,
      if (denominator != null) #denominator: denominator,
    }),
  );
  @override
  SExactRational $make(CopyWithData data) => SExactRational(
    data.get(#radix, or: $value.radix),
    data.get(#numerator, or: $value.numerator),
    data.get(#denominator, or: $value.denominator),
  );

  @override
  SExactRationalCopyWith<$R2, SExactRational, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SExactRationalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SExactWithRadixPointMapper extends ClassMapperBase<SExactWithRadixPoint> {
  SExactWithRadixPointMapper._();

  static SExactWithRadixPointMapper? _instance;
  static SExactWithRadixPointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SExactWithRadixPointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SExactWithRadixPoint';

  static BigDecimal _$value(SExactWithRadixPoint v) => v.value;
  static const Field<SExactWithRadixPoint, BigDecimal> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<SExactWithRadixPoint> fields = const {#value: _f$value};

  static SExactWithRadixPoint _instantiate(DecodingData data) {
    return SExactWithRadixPoint(data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static SExactWithRadixPoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SExactWithRadixPoint>(map);
  }

  static SExactWithRadixPoint fromJson(String json) {
    return ensureInitialized().decodeJson<SExactWithRadixPoint>(json);
  }
}

mixin SExactWithRadixPointMappable {
  String toJson() {
    return SExactWithRadixPointMapper.ensureInitialized()
        .encodeJson<SExactWithRadixPoint>(this as SExactWithRadixPoint);
  }

  Map<String, dynamic> toMap() {
    return SExactWithRadixPointMapper.ensureInitialized()
        .encodeMap<SExactWithRadixPoint>(this as SExactWithRadixPoint);
  }

  SExactWithRadixPointCopyWith<
    SExactWithRadixPoint,
    SExactWithRadixPoint,
    SExactWithRadixPoint
  >
  get copyWith =>
      _SExactWithRadixPointCopyWithImpl<
        SExactWithRadixPoint,
        SExactWithRadixPoint
      >(this as SExactWithRadixPoint, $identity, $identity);
  @override
  String toString() {
    return SExactWithRadixPointMapper.ensureInitialized().stringifyValue(
      this as SExactWithRadixPoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return SExactWithRadixPointMapper.ensureInitialized().equalsValue(
      this as SExactWithRadixPoint,
      other,
    );
  }

  @override
  int get hashCode {
    return SExactWithRadixPointMapper.ensureInitialized().hashValue(
      this as SExactWithRadixPoint,
    );
  }
}

extension SExactWithRadixPointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SExactWithRadixPoint, $Out> {
  SExactWithRadixPointCopyWith<$R, SExactWithRadixPoint, $Out>
  get $asSExactWithRadixPoint => $base.as(
    (v, t, t2) => _SExactWithRadixPointCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SExactWithRadixPointCopyWith<
  $R,
  $In extends SExactWithRadixPoint,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({BigDecimal? value});
  SExactWithRadixPointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SExactWithRadixPointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SExactWithRadixPoint, $Out>
    implements SExactWithRadixPointCopyWith<$R, SExactWithRadixPoint, $Out> {
  _SExactWithRadixPointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SExactWithRadixPoint> $mapper =
      SExactWithRadixPointMapper.ensureInitialized();
  @override
  $R call({BigDecimal? value}) =>
      $apply(FieldCopyWithData({if (value != null) #value: value}));
  @override
  SExactWithRadixPoint $make(CopyWithData data) =>
      SExactWithRadixPoint(data.get(#value, or: $value.value));

  @override
  SExactWithRadixPointCopyWith<$R2, SExactWithRadixPoint, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SExactWithRadixPointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SExactIntegerMapper extends ClassMapperBase<SExactInteger> {
  SExactIntegerMapper._();

  static SExactIntegerMapper? _instance;
  static SExactIntegerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SExactIntegerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SExactInteger';

  static Radix _$radix(SExactInteger v) => v.radix;
  static const Field<SExactInteger, Radix> _f$radix = Field('radix', _$radix);
  static BigInt _$value(SExactInteger v) => v.value;
  static const Field<SExactInteger, BigInt> _f$value = Field('value', _$value);

  @override
  final MappableFields<SExactInteger> fields = const {
    #radix: _f$radix,
    #value: _f$value,
  };

  static SExactInteger _instantiate(DecodingData data) {
    return SExactInteger(data.dec(_f$radix), data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static SExactInteger fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SExactInteger>(map);
  }

  static SExactInteger fromJson(String json) {
    return ensureInitialized().decodeJson<SExactInteger>(json);
  }
}

mixin SExactIntegerMappable {
  String toJson() {
    return SExactIntegerMapper.ensureInitialized().encodeJson<SExactInteger>(
      this as SExactInteger,
    );
  }

  Map<String, dynamic> toMap() {
    return SExactIntegerMapper.ensureInitialized().encodeMap<SExactInteger>(
      this as SExactInteger,
    );
  }

  SExactIntegerCopyWith<SExactInteger, SExactInteger, SExactInteger>
  get copyWith => _SExactIntegerCopyWithImpl<SExactInteger, SExactInteger>(
    this as SExactInteger,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SExactIntegerMapper.ensureInitialized().stringifyValue(
      this as SExactInteger,
    );
  }

  @override
  bool operator ==(Object other) {
    return SExactIntegerMapper.ensureInitialized().equalsValue(
      this as SExactInteger,
      other,
    );
  }

  @override
  int get hashCode {
    return SExactIntegerMapper.ensureInitialized().hashValue(
      this as SExactInteger,
    );
  }
}

extension SExactIntegerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SExactInteger, $Out> {
  SExactIntegerCopyWith<$R, SExactInteger, $Out> get $asSExactInteger =>
      $base.as((v, t, t2) => _SExactIntegerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SExactIntegerCopyWith<$R, $In extends SExactInteger, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Radix? radix, BigInt? value});
  SExactIntegerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SExactIntegerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SExactInteger, $Out>
    implements SExactIntegerCopyWith<$R, SExactInteger, $Out> {
  _SExactIntegerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SExactInteger> $mapper =
      SExactIntegerMapper.ensureInitialized();
  @override
  $R call({Radix? radix, BigInt? value}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (value != null) #value: value,
    }),
  );
  @override
  SExactInteger $make(CopyWithData data) => SExactInteger(
    data.get(#radix, or: $value.radix),
    data.get(#value, or: $value.value),
  );

  @override
  SExactIntegerCopyWith<$R2, SExactInteger, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SExactIntegerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SInexactRealMapper extends ClassMapperBase<SInexactReal> {
  SInexactRealMapper._();

  static SInexactRealMapper? _instance;
  static SInexactRealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SInexactRealMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SInexactReal';

  static Radix _$radix(SInexactReal v) => v.radix;
  static const Field<SInexactReal, Radix> _f$radix = Field('radix', _$radix);
  static double _$value(SInexactReal v) => v.value;
  static const Field<SInexactReal, double> _f$value = Field('value', _$value);

  @override
  final MappableFields<SInexactReal> fields = const {
    #radix: _f$radix,
    #value: _f$value,
  };

  static SInexactReal _instantiate(DecodingData data) {
    return SInexactReal(data.dec(_f$radix), data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static SInexactReal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SInexactReal>(map);
  }

  static SInexactReal fromJson(String json) {
    return ensureInitialized().decodeJson<SInexactReal>(json);
  }
}

mixin SInexactRealMappable {
  String toJson() {
    return SInexactRealMapper.ensureInitialized().encodeJson<SInexactReal>(
      this as SInexactReal,
    );
  }

  Map<String, dynamic> toMap() {
    return SInexactRealMapper.ensureInitialized().encodeMap<SInexactReal>(
      this as SInexactReal,
    );
  }

  SInexactRealCopyWith<SInexactReal, SInexactReal, SInexactReal> get copyWith =>
      _SInexactRealCopyWithImpl<SInexactReal, SInexactReal>(
        this as SInexactReal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SInexactRealMapper.ensureInitialized().stringifyValue(
      this as SInexactReal,
    );
  }

  @override
  bool operator ==(Object other) {
    return SInexactRealMapper.ensureInitialized().equalsValue(
      this as SInexactReal,
      other,
    );
  }

  @override
  int get hashCode {
    return SInexactRealMapper.ensureInitialized().hashValue(
      this as SInexactReal,
    );
  }
}

extension SInexactRealValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SInexactReal, $Out> {
  SInexactRealCopyWith<$R, SInexactReal, $Out> get $asSInexactReal =>
      $base.as((v, t, t2) => _SInexactRealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SInexactRealCopyWith<$R, $In extends SInexactReal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Radix? radix, double? value});
  SInexactRealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SInexactRealCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SInexactReal, $Out>
    implements SInexactRealCopyWith<$R, SInexactReal, $Out> {
  _SInexactRealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SInexactReal> $mapper =
      SInexactRealMapper.ensureInitialized();
  @override
  $R call({Radix? radix, double? value}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (value != null) #value: value,
    }),
  );
  @override
  SInexactReal $make(CopyWithData data) => SInexactReal(
    data.get(#radix, or: $value.radix),
    data.get(#value, or: $value.value),
  );

  @override
  SInexactRealCopyWith<$R2, SInexactReal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SInexactRealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SExactComplexMapper extends ClassMapperBase<SExactComplex> {
  SExactComplexMapper._();

  static SExactComplexMapper? _instance;
  static SExactComplexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SExactComplexMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SExactComplex';

  static Radix _$radix(SExactComplex v) => v.radix;
  static const Field<SExactComplex, Radix> _f$radix = Field('radix', _$radix);
  static SExactReal _$real(SExactComplex v) => v.real;
  static const Field<SExactComplex, SExactReal> _f$real = Field('real', _$real);
  static SExactReal _$imag(SExactComplex v) => v.imag;
  static const Field<SExactComplex, SExactReal> _f$imag = Field('imag', _$imag);

  @override
  final MappableFields<SExactComplex> fields = const {
    #radix: _f$radix,
    #real: _f$real,
    #imag: _f$imag,
  };

  static SExactComplex _instantiate(DecodingData data) {
    return SExactComplex(
      data.dec(_f$radix),
      data.dec(_f$real),
      data.dec(_f$imag),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SExactComplex fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SExactComplex>(map);
  }

  static SExactComplex fromJson(String json) {
    return ensureInitialized().decodeJson<SExactComplex>(json);
  }
}

mixin SExactComplexMappable {
  String toJson() {
    return SExactComplexMapper.ensureInitialized().encodeJson<SExactComplex>(
      this as SExactComplex,
    );
  }

  Map<String, dynamic> toMap() {
    return SExactComplexMapper.ensureInitialized().encodeMap<SExactComplex>(
      this as SExactComplex,
    );
  }

  SExactComplexCopyWith<SExactComplex, SExactComplex, SExactComplex>
  get copyWith => _SExactComplexCopyWithImpl<SExactComplex, SExactComplex>(
    this as SExactComplex,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SExactComplexMapper.ensureInitialized().stringifyValue(
      this as SExactComplex,
    );
  }

  @override
  bool operator ==(Object other) {
    return SExactComplexMapper.ensureInitialized().equalsValue(
      this as SExactComplex,
      other,
    );
  }

  @override
  int get hashCode {
    return SExactComplexMapper.ensureInitialized().hashValue(
      this as SExactComplex,
    );
  }
}

extension SExactComplexValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SExactComplex, $Out> {
  SExactComplexCopyWith<$R, SExactComplex, $Out> get $asSExactComplex =>
      $base.as((v, t, t2) => _SExactComplexCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SExactComplexCopyWith<$R, $In extends SExactComplex, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Radix? radix, SExactReal? real, SExactReal? imag});
  SExactComplexCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SExactComplexCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SExactComplex, $Out>
    implements SExactComplexCopyWith<$R, SExactComplex, $Out> {
  _SExactComplexCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SExactComplex> $mapper =
      SExactComplexMapper.ensureInitialized();
  @override
  $R call({Radix? radix, SExactReal? real, SExactReal? imag}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (real != null) #real: real,
      if (imag != null) #imag: imag,
    }),
  );
  @override
  SExactComplex $make(CopyWithData data) => SExactComplex(
    data.get(#radix, or: $value.radix),
    data.get(#real, or: $value.real),
    data.get(#imag, or: $value.imag),
  );

  @override
  SExactComplexCopyWith<$R2, SExactComplex, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SExactComplexCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SInexactComplexMapper extends ClassMapperBase<SInexactComplex> {
  SInexactComplexMapper._();

  static SInexactComplexMapper? _instance;
  static SInexactComplexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SInexactComplexMapper._());
      SInexactRealMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SInexactComplex';

  static Radix _$radix(SInexactComplex v) => v.radix;
  static const Field<SInexactComplex, Radix> _f$radix = Field('radix', _$radix);
  static SInexactReal _$real(SInexactComplex v) => v.real;
  static const Field<SInexactComplex, SInexactReal> _f$real = Field(
    'real',
    _$real,
  );
  static SInexactReal _$imag(SInexactComplex v) => v.imag;
  static const Field<SInexactComplex, SInexactReal> _f$imag = Field(
    'imag',
    _$imag,
  );

  @override
  final MappableFields<SInexactComplex> fields = const {
    #radix: _f$radix,
    #real: _f$real,
    #imag: _f$imag,
  };

  static SInexactComplex _instantiate(DecodingData data) {
    return SInexactComplex(
      data.dec(_f$radix),
      data.dec(_f$real),
      data.dec(_f$imag),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SInexactComplex fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SInexactComplex>(map);
  }

  static SInexactComplex fromJson(String json) {
    return ensureInitialized().decodeJson<SInexactComplex>(json);
  }
}

mixin SInexactComplexMappable {
  String toJson() {
    return SInexactComplexMapper.ensureInitialized()
        .encodeJson<SInexactComplex>(this as SInexactComplex);
  }

  Map<String, dynamic> toMap() {
    return SInexactComplexMapper.ensureInitialized().encodeMap<SInexactComplex>(
      this as SInexactComplex,
    );
  }

  SInexactComplexCopyWith<SInexactComplex, SInexactComplex, SInexactComplex>
  get copyWith =>
      _SInexactComplexCopyWithImpl<SInexactComplex, SInexactComplex>(
        this as SInexactComplex,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SInexactComplexMapper.ensureInitialized().stringifyValue(
      this as SInexactComplex,
    );
  }

  @override
  bool operator ==(Object other) {
    return SInexactComplexMapper.ensureInitialized().equalsValue(
      this as SInexactComplex,
      other,
    );
  }

  @override
  int get hashCode {
    return SInexactComplexMapper.ensureInitialized().hashValue(
      this as SInexactComplex,
    );
  }
}

extension SInexactComplexValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SInexactComplex, $Out> {
  SInexactComplexCopyWith<$R, SInexactComplex, $Out> get $asSInexactComplex =>
      $base.as((v, t, t2) => _SInexactComplexCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SInexactComplexCopyWith<$R, $In extends SInexactComplex, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SInexactRealCopyWith<$R, SInexactReal, SInexactReal> get real;
  SInexactRealCopyWith<$R, SInexactReal, SInexactReal> get imag;
  $R call({Radix? radix, SInexactReal? real, SInexactReal? imag});
  SInexactComplexCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SInexactComplexCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SInexactComplex, $Out>
    implements SInexactComplexCopyWith<$R, SInexactComplex, $Out> {
  _SInexactComplexCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SInexactComplex> $mapper =
      SInexactComplexMapper.ensureInitialized();
  @override
  SInexactRealCopyWith<$R, SInexactReal, SInexactReal> get real =>
      $value.real.copyWith.$chain((v) => call(real: v));
  @override
  SInexactRealCopyWith<$R, SInexactReal, SInexactReal> get imag =>
      $value.imag.copyWith.$chain((v) => call(imag: v));
  @override
  $R call({Radix? radix, SInexactReal? real, SInexactReal? imag}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (real != null) #real: real,
      if (imag != null) #imag: imag,
    }),
  );
  @override
  SInexactComplex $make(CopyWithData data) => SInexactComplex(
    data.get(#radix, or: $value.radix),
    data.get(#real, or: $value.real),
    data.get(#imag, or: $value.imag),
  );

  @override
  SInexactComplexCopyWith<$R2, SInexactComplex, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SInexactComplexCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

