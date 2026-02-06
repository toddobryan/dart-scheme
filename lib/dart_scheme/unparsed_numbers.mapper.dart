// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'unparsed_numbers.dart';

class PrefixMapper extends ClassMapperBase<Prefix> {
  PrefixMapper._();

  static PrefixMapper? _instance;
  static PrefixMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PrefixMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Prefix';

  static String _$input(Prefix v) => v.input;
  static const Field<Prefix, String> _f$input = Field('input', _$input);
  static Radix _$radix(Prefix v) => v.radix;
  static const Field<Prefix, Radix> _f$radix = Field('radix', _$radix);
  static Exactness _$exactness(Prefix v) => v.exactness;
  static const Field<Prefix, Exactness> _f$exactness = Field(
    'exactness',
    _$exactness,
  );

  @override
  final MappableFields<Prefix> fields = const {
    #input: _f$input,
    #radix: _f$radix,
    #exactness: _f$exactness,
  };

  static Prefix _instantiate(DecodingData data) {
    return Prefix(
      data.dec(_f$input),
      data.dec(_f$radix),
      data.dec(_f$exactness),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Prefix fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Prefix>(map);
  }

  static Prefix fromJson(String json) {
    return ensureInitialized().decodeJson<Prefix>(json);
  }
}

mixin PrefixMappable {
  String toJson() {
    return PrefixMapper.ensureInitialized().encodeJson<Prefix>(this as Prefix);
  }

  Map<String, dynamic> toMap() {
    return PrefixMapper.ensureInitialized().encodeMap<Prefix>(this as Prefix);
  }

  PrefixCopyWith<Prefix, Prefix, Prefix> get copyWith =>
      _PrefixCopyWithImpl<Prefix, Prefix>(this as Prefix, $identity, $identity);
  @override
  String toString() {
    return PrefixMapper.ensureInitialized().stringifyValue(this as Prefix);
  }

  @override
  bool operator ==(Object other) {
    return PrefixMapper.ensureInitialized().equalsValue(this as Prefix, other);
  }

  @override
  int get hashCode {
    return PrefixMapper.ensureInitialized().hashValue(this as Prefix);
  }
}

extension PrefixValueCopy<$R, $Out> on ObjectCopyWith<$R, Prefix, $Out> {
  PrefixCopyWith<$R, Prefix, $Out> get $asPrefix =>
      $base.as((v, t, t2) => _PrefixCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PrefixCopyWith<$R, $In extends Prefix, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input, Radix? radix, Exactness? exactness});
  PrefixCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PrefixCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Prefix, $Out>
    implements PrefixCopyWith<$R, Prefix, $Out> {
  _PrefixCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Prefix> $mapper = PrefixMapper.ensureInitialized();
  @override
  $R call({String? input, Radix? radix, Exactness? exactness}) => $apply(
    FieldCopyWithData({
      if (input != null) #input: input,
      if (radix != null) #radix: radix,
      if (exactness != null) #exactness: exactness,
    }),
  );
  @override
  Prefix $make(CopyWithData data) => Prefix(
    data.get(#input, or: $value.input),
    data.get(#radix, or: $value.radix),
    data.get(#exactness, or: $value.exactness),
  );

  @override
  PrefixCopyWith<$R2, Prefix, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PrefixCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PrefixedNumStringMapper extends ClassMapperBase<PrefixedNumString> {
  PrefixedNumStringMapper._();

  static PrefixedNumStringMapper? _instance;
  static PrefixedNumStringMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PrefixedNumStringMapper._());
      PrefixMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PrefixedNumString';

  static Prefix _$prefix(PrefixedNumString v) => v.prefix;
  static const Field<PrefixedNumString, Prefix> _f$prefix = Field(
    'prefix',
    _$prefix,
  );
  static NumString _$numString(PrefixedNumString v) => v.numString;
  static const Field<PrefixedNumString, NumString> _f$numString = Field(
    'numString',
    _$numString,
  );

  @override
  final MappableFields<PrefixedNumString> fields = const {
    #prefix: _f$prefix,
    #numString: _f$numString,
  };

  static PrefixedNumString _instantiate(DecodingData data) {
    return PrefixedNumString(data.dec(_f$prefix), data.dec(_f$numString));
  }

  @override
  final Function instantiate = _instantiate;

  static PrefixedNumString fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PrefixedNumString>(map);
  }

  static PrefixedNumString fromJson(String json) {
    return ensureInitialized().decodeJson<PrefixedNumString>(json);
  }
}

mixin PrefixedNumStringMappable {
  String toJson() {
    return PrefixedNumStringMapper.ensureInitialized()
        .encodeJson<PrefixedNumString>(this as PrefixedNumString);
  }

  Map<String, dynamic> toMap() {
    return PrefixedNumStringMapper.ensureInitialized()
        .encodeMap<PrefixedNumString>(this as PrefixedNumString);
  }

  PrefixedNumStringCopyWith<
    PrefixedNumString,
    PrefixedNumString,
    PrefixedNumString
  >
  get copyWith =>
      _PrefixedNumStringCopyWithImpl<PrefixedNumString, PrefixedNumString>(
        this as PrefixedNumString,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PrefixedNumStringMapper.ensureInitialized().stringifyValue(
      this as PrefixedNumString,
    );
  }

  @override
  bool operator ==(Object other) {
    return PrefixedNumStringMapper.ensureInitialized().equalsValue(
      this as PrefixedNumString,
      other,
    );
  }

  @override
  int get hashCode {
    return PrefixedNumStringMapper.ensureInitialized().hashValue(
      this as PrefixedNumString,
    );
  }
}

extension PrefixedNumStringValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PrefixedNumString, $Out> {
  PrefixedNumStringCopyWith<$R, PrefixedNumString, $Out>
  get $asPrefixedNumString => $base.as(
    (v, t, t2) => _PrefixedNumStringCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PrefixedNumStringCopyWith<
  $R,
  $In extends PrefixedNumString,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PrefixCopyWith<$R, Prefix, Prefix> get prefix;
  $R call({Prefix? prefix, NumString? numString});
  PrefixedNumStringCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PrefixedNumStringCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PrefixedNumString, $Out>
    implements PrefixedNumStringCopyWith<$R, PrefixedNumString, $Out> {
  _PrefixedNumStringCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PrefixedNumString> $mapper =
      PrefixedNumStringMapper.ensureInitialized();
  @override
  PrefixCopyWith<$R, Prefix, Prefix> get prefix =>
      $value.prefix.copyWith.$chain((v) => call(prefix: v));
  @override
  $R call({Prefix? prefix, NumString? numString}) => $apply(
    FieldCopyWithData({
      if (prefix != null) #prefix: prefix,
      if (numString != null) #numString: numString,
    }),
  );
  @override
  PrefixedNumString $make(CopyWithData data) => PrefixedNumString(
    data.get(#prefix, or: $value.prefix),
    data.get(#numString, or: $value.numString),
  );

  @override
  PrefixedNumStringCopyWith<$R2, PrefixedNumString, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PrefixedNumStringCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SuffixMapper extends ClassMapperBase<Suffix> {
  SuffixMapper._();

  static SuffixMapper? _instance;
  static SuffixMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SuffixMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Suffix';

  static String _$input(Suffix v) => v.input;
  static const Field<Suffix, String> _f$input = Field('input', _$input);

  @override
  final MappableFields<Suffix> fields = const {#input: _f$input};

  static Suffix _instantiate(DecodingData data) {
    return Suffix(data.dec(_f$input));
  }

  @override
  final Function instantiate = _instantiate;

  static Suffix fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Suffix>(map);
  }

  static Suffix fromJson(String json) {
    return ensureInitialized().decodeJson<Suffix>(json);
  }
}

mixin SuffixMappable {
  String toJson() {
    return SuffixMapper.ensureInitialized().encodeJson<Suffix>(this as Suffix);
  }

  Map<String, dynamic> toMap() {
    return SuffixMapper.ensureInitialized().encodeMap<Suffix>(this as Suffix);
  }

  SuffixCopyWith<Suffix, Suffix, Suffix> get copyWith =>
      _SuffixCopyWithImpl<Suffix, Suffix>(this as Suffix, $identity, $identity);
  @override
  String toString() {
    return SuffixMapper.ensureInitialized().stringifyValue(this as Suffix);
  }

  @override
  bool operator ==(Object other) {
    return SuffixMapper.ensureInitialized().equalsValue(this as Suffix, other);
  }

  @override
  int get hashCode {
    return SuffixMapper.ensureInitialized().hashValue(this as Suffix);
  }
}

extension SuffixValueCopy<$R, $Out> on ObjectCopyWith<$R, Suffix, $Out> {
  SuffixCopyWith<$R, Suffix, $Out> get $asSuffix =>
      $base.as((v, t, t2) => _SuffixCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SuffixCopyWith<$R, $In extends Suffix, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input});
  SuffixCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SuffixCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Suffix, $Out>
    implements SuffixCopyWith<$R, Suffix, $Out> {
  _SuffixCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Suffix> $mapper = SuffixMapper.ensureInitialized();
  @override
  $R call({String? input}) =>
      $apply(FieldCopyWithData({if (input != null) #input: input}));
  @override
  Suffix $make(CopyWithData data) => Suffix(data.get(#input, or: $value.input));

  @override
  SuffixCopyWith<$R2, Suffix, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SuffixCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class WithRadixPointMapper extends ClassMapperBase<WithRadixPoint> {
  WithRadixPointMapper._();

  static WithRadixPointMapper? _instance;
  static WithRadixPointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WithRadixPointMapper._());
      SuffixMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WithRadixPoint';

  static String _$beforeDot(WithRadixPoint v) => v.beforeDot;
  static const Field<WithRadixPoint, String> _f$beforeDot = Field(
    'beforeDot',
    _$beforeDot,
  );
  static String? _$afterDot(WithRadixPoint v) => v.afterDot;
  static const Field<WithRadixPoint, String> _f$afterDot = Field(
    'afterDot',
    _$afterDot,
  );
  static Suffix _$suffix(WithRadixPoint v) => v.suffix;
  static const Field<WithRadixPoint, Suffix> _f$suffix = Field(
    'suffix',
    _$suffix,
  );

  @override
  final MappableFields<WithRadixPoint> fields = const {
    #beforeDot: _f$beforeDot,
    #afterDot: _f$afterDot,
    #suffix: _f$suffix,
  };

  static WithRadixPoint _instantiate(DecodingData data) {
    return WithRadixPoint(
      data.dec(_f$beforeDot),
      data.dec(_f$afterDot),
      data.dec(_f$suffix),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WithRadixPoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WithRadixPoint>(map);
  }

  static WithRadixPoint fromJson(String json) {
    return ensureInitialized().decodeJson<WithRadixPoint>(json);
  }
}

mixin WithRadixPointMappable {
  String toJson() {
    return WithRadixPointMapper.ensureInitialized().encodeJson<WithRadixPoint>(
      this as WithRadixPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return WithRadixPointMapper.ensureInitialized().encodeMap<WithRadixPoint>(
      this as WithRadixPoint,
    );
  }

  WithRadixPointCopyWith<WithRadixPoint, WithRadixPoint, WithRadixPoint>
  get copyWith => _WithRadixPointCopyWithImpl<WithRadixPoint, WithRadixPoint>(
    this as WithRadixPoint,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return WithRadixPointMapper.ensureInitialized().stringifyValue(
      this as WithRadixPoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return WithRadixPointMapper.ensureInitialized().equalsValue(
      this as WithRadixPoint,
      other,
    );
  }

  @override
  int get hashCode {
    return WithRadixPointMapper.ensureInitialized().hashValue(
      this as WithRadixPoint,
    );
  }
}

extension WithRadixPointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WithRadixPoint, $Out> {
  WithRadixPointCopyWith<$R, WithRadixPoint, $Out> get $asWithRadixPoint =>
      $base.as((v, t, t2) => _WithRadixPointCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WithRadixPointCopyWith<$R, $In extends WithRadixPoint, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SuffixCopyWith<$R, Suffix, Suffix> get suffix;
  $R call({String? beforeDot, String? afterDot, Suffix? suffix});
  WithRadixPointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _WithRadixPointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WithRadixPoint, $Out>
    implements WithRadixPointCopyWith<$R, WithRadixPoint, $Out> {
  _WithRadixPointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WithRadixPoint> $mapper =
      WithRadixPointMapper.ensureInitialized();
  @override
  SuffixCopyWith<$R, Suffix, Suffix> get suffix =>
      $value.suffix.copyWith.$chain((v) => call(suffix: v));
  @override
  $R call({String? beforeDot, Object? afterDot = $none, Suffix? suffix}) =>
      $apply(
        FieldCopyWithData({
          if (beforeDot != null) #beforeDot: beforeDot,
          if (afterDot != $none) #afterDot: afterDot,
          if (suffix != null) #suffix: suffix,
        }),
      );
  @override
  WithRadixPoint $make(CopyWithData data) => WithRadixPoint(
    data.get(#beforeDot, or: $value.beforeDot),
    data.get(#afterDot, or: $value.afterDot),
    data.get(#suffix, or: $value.suffix),
  );

  @override
  WithRadixPointCopyWith<$R2, WithRadixPoint, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WithRadixPointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class WeirdNumMapper extends ClassMapperBase<WeirdNum> {
  WeirdNumMapper._();

  static WeirdNumMapper? _instance;
  static WeirdNumMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WeirdNumMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'WeirdNum';

  static String _$input(WeirdNum v) => v.input;
  static const Field<WeirdNum, String> _f$input = Field('input', _$input);
  static double _$value(WeirdNum v) => v.value;
  static const Field<WeirdNum, double> _f$value = Field('value', _$value);

  @override
  final MappableFields<WeirdNum> fields = const {
    #input: _f$input,
    #value: _f$value,
  };

  static WeirdNum _instantiate(DecodingData data) {
    return WeirdNum(data.dec(_f$input), data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static WeirdNum fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WeirdNum>(map);
  }

  static WeirdNum fromJson(String json) {
    return ensureInitialized().decodeJson<WeirdNum>(json);
  }
}

mixin WeirdNumMappable {
  String toJson() {
    return WeirdNumMapper.ensureInitialized().encodeJson<WeirdNum>(
      this as WeirdNum,
    );
  }

  Map<String, dynamic> toMap() {
    return WeirdNumMapper.ensureInitialized().encodeMap<WeirdNum>(
      this as WeirdNum,
    );
  }

  WeirdNumCopyWith<WeirdNum, WeirdNum, WeirdNum> get copyWith =>
      _WeirdNumCopyWithImpl<WeirdNum, WeirdNum>(
        this as WeirdNum,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return WeirdNumMapper.ensureInitialized().stringifyValue(this as WeirdNum);
  }

  @override
  bool operator ==(Object other) {
    return WeirdNumMapper.ensureInitialized().equalsValue(
      this as WeirdNum,
      other,
    );
  }

  @override
  int get hashCode {
    return WeirdNumMapper.ensureInitialized().hashValue(this as WeirdNum);
  }
}

extension WeirdNumValueCopy<$R, $Out> on ObjectCopyWith<$R, WeirdNum, $Out> {
  WeirdNumCopyWith<$R, WeirdNum, $Out> get $asWeirdNum =>
      $base.as((v, t, t2) => _WeirdNumCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WeirdNumCopyWith<$R, $In extends WeirdNum, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input, double? value});
  WeirdNumCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WeirdNumCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WeirdNum, $Out>
    implements WeirdNumCopyWith<$R, WeirdNum, $Out> {
  _WeirdNumCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WeirdNum> $mapper =
      WeirdNumMapper.ensureInitialized();
  @override
  $R call({String? input, double? value}) => $apply(
    FieldCopyWithData({
      if (input != null) #input: input,
      if (value != null) #value: value,
    }),
  );
  @override
  WeirdNum $make(CopyWithData data) => WeirdNum(
    data.get(#input, or: $value.input),
    data.get(#value, or: $value.value),
  );

  @override
  WeirdNumCopyWith<$R2, WeirdNum, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WeirdNumCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class IntStringMapper extends ClassMapperBase<IntString> {
  IntStringMapper._();

  static IntStringMapper? _instance;
  static IntStringMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IntStringMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'IntString';

  static String _$input(IntString v) => v.input;
  static const Field<IntString, String> _f$input = Field('input', _$input);
  static Radix _$radix(IntString v) => v.radix;
  static const Field<IntString, Radix> _f$radix = Field('radix', _$radix);
  static String _$digits(IntString v) => v.digits;
  static const Field<IntString, String> _f$digits = Field('digits', _$digits);

  @override
  final MappableFields<IntString> fields = const {
    #input: _f$input,
    #radix: _f$radix,
    #digits: _f$digits,
  };

  static IntString _instantiate(DecodingData data) {
    return IntString(
      data.dec(_f$input),
      data.dec(_f$radix),
      data.dec(_f$digits),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static IntString fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IntString>(map);
  }

  static IntString fromJson(String json) {
    return ensureInitialized().decodeJson<IntString>(json);
  }
}

mixin IntStringMappable {
  String toJson() {
    return IntStringMapper.ensureInitialized().encodeJson<IntString>(
      this as IntString,
    );
  }

  Map<String, dynamic> toMap() {
    return IntStringMapper.ensureInitialized().encodeMap<IntString>(
      this as IntString,
    );
  }

  IntStringCopyWith<IntString, IntString, IntString> get copyWith =>
      _IntStringCopyWithImpl<IntString, IntString>(
        this as IntString,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return IntStringMapper.ensureInitialized().stringifyValue(
      this as IntString,
    );
  }

  @override
  bool operator ==(Object other) {
    return IntStringMapper.ensureInitialized().equalsValue(
      this as IntString,
      other,
    );
  }

  @override
  int get hashCode {
    return IntStringMapper.ensureInitialized().hashValue(this as IntString);
  }
}

extension IntStringValueCopy<$R, $Out> on ObjectCopyWith<$R, IntString, $Out> {
  IntStringCopyWith<$R, IntString, $Out> get $asIntString =>
      $base.as((v, t, t2) => _IntStringCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IntStringCopyWith<$R, $In extends IntString, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input, Radix? radix, String? digits});
  IntStringCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _IntStringCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IntString, $Out>
    implements IntStringCopyWith<$R, IntString, $Out> {
  _IntStringCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IntString> $mapper =
      IntStringMapper.ensureInitialized();
  @override
  $R call({String? input, Radix? radix, String? digits}) => $apply(
    FieldCopyWithData({
      if (input != null) #input: input,
      if (radix != null) #radix: radix,
      if (digits != null) #digits: digits,
    }),
  );
  @override
  IntString $make(CopyWithData data) => IntString(
    data.get(#input, or: $value.input),
    data.get(#radix, or: $value.radix),
    data.get(#digits, or: $value.digits),
  );

  @override
  IntStringCopyWith<$R2, IntString, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _IntStringCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FracStringMapper extends ClassMapperBase<FracString> {
  FracStringMapper._();

  static FracStringMapper? _instance;
  static FracStringMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FracStringMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FracString';

  static Radix _$radix(FracString v) => v.radix;
  static const Field<FracString, Radix> _f$radix = Field('radix', _$radix);
  static String _$numerator(FracString v) => v.numerator;
  static const Field<FracString, String> _f$numerator = Field(
    'numerator',
    _$numerator,
  );
  static String _$denominator(FracString v) => v.denominator;
  static const Field<FracString, String> _f$denominator = Field(
    'denominator',
    _$denominator,
  );

  @override
  final MappableFields<FracString> fields = const {
    #radix: _f$radix,
    #numerator: _f$numerator,
    #denominator: _f$denominator,
  };

  static FracString _instantiate(DecodingData data) {
    return FracString(
      data.dec(_f$radix),
      data.dec(_f$numerator),
      data.dec(_f$denominator),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FracString fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FracString>(map);
  }

  static FracString fromJson(String json) {
    return ensureInitialized().decodeJson<FracString>(json);
  }
}

mixin FracStringMappable {
  String toJson() {
    return FracStringMapper.ensureInitialized().encodeJson<FracString>(
      this as FracString,
    );
  }

  Map<String, dynamic> toMap() {
    return FracStringMapper.ensureInitialized().encodeMap<FracString>(
      this as FracString,
    );
  }

  FracStringCopyWith<FracString, FracString, FracString> get copyWith =>
      _FracStringCopyWithImpl<FracString, FracString>(
        this as FracString,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FracStringMapper.ensureInitialized().stringifyValue(
      this as FracString,
    );
  }

  @override
  bool operator ==(Object other) {
    return FracStringMapper.ensureInitialized().equalsValue(
      this as FracString,
      other,
    );
  }

  @override
  int get hashCode {
    return FracStringMapper.ensureInitialized().hashValue(this as FracString);
  }
}

extension FracStringValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FracString, $Out> {
  FracStringCopyWith<$R, FracString, $Out> get $asFracString =>
      $base.as((v, t, t2) => _FracStringCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FracStringCopyWith<$R, $In extends FracString, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Radix? radix, String? numerator, String? denominator});
  FracStringCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FracStringCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FracString, $Out>
    implements FracStringCopyWith<$R, FracString, $Out> {
  _FracStringCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FracString> $mapper =
      FracStringMapper.ensureInitialized();
  @override
  $R call({Radix? radix, String? numerator, String? denominator}) => $apply(
    FieldCopyWithData({
      if (radix != null) #radix: radix,
      if (numerator != null) #numerator: numerator,
      if (denominator != null) #denominator: denominator,
    }),
  );
  @override
  FracString $make(CopyWithData data) => FracString(
    data.get(#radix, or: $value.radix),
    data.get(#numerator, or: $value.numerator),
    data.get(#denominator, or: $value.denominator),
  );

  @override
  FracStringCopyWith<$R2, FracString, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FracStringCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CartesianComplexStringMapper
    extends ClassMapperBase<CartesianComplexString> {
  CartesianComplexStringMapper._();

  static CartesianComplexStringMapper? _instance;
  static CartesianComplexStringMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CartesianComplexStringMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CartesianComplexString';

  static String _$input(CartesianComplexString v) => v.input;
  static const Field<CartesianComplexString, String> _f$input = Field(
    'input',
    _$input,
  );
  static RealString _$real(CartesianComplexString v) => v.real;
  static const Field<CartesianComplexString, RealString> _f$real = Field(
    'real',
    _$real,
  );
  static RealString _$imag(CartesianComplexString v) => v.imag;
  static const Field<CartesianComplexString, RealString> _f$imag = Field(
    'imag',
    _$imag,
  );

  @override
  final MappableFields<CartesianComplexString> fields = const {
    #input: _f$input,
    #real: _f$real,
    #imag: _f$imag,
  };

  static CartesianComplexString _instantiate(DecodingData data) {
    return CartesianComplexString(
      data.dec(_f$input),
      data.dec(_f$real),
      data.dec(_f$imag),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CartesianComplexString fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CartesianComplexString>(map);
  }

  static CartesianComplexString fromJson(String json) {
    return ensureInitialized().decodeJson<CartesianComplexString>(json);
  }
}

mixin CartesianComplexStringMappable {
  String toJson() {
    return CartesianComplexStringMapper.ensureInitialized()
        .encodeJson<CartesianComplexString>(this as CartesianComplexString);
  }

  Map<String, dynamic> toMap() {
    return CartesianComplexStringMapper.ensureInitialized()
        .encodeMap<CartesianComplexString>(this as CartesianComplexString);
  }

  CartesianComplexStringCopyWith<
    CartesianComplexString,
    CartesianComplexString,
    CartesianComplexString
  >
  get copyWith =>
      _CartesianComplexStringCopyWithImpl<
        CartesianComplexString,
        CartesianComplexString
      >(this as CartesianComplexString, $identity, $identity);
  @override
  String toString() {
    return CartesianComplexStringMapper.ensureInitialized().stringifyValue(
      this as CartesianComplexString,
    );
  }

  @override
  bool operator ==(Object other) {
    return CartesianComplexStringMapper.ensureInitialized().equalsValue(
      this as CartesianComplexString,
      other,
    );
  }

  @override
  int get hashCode {
    return CartesianComplexStringMapper.ensureInitialized().hashValue(
      this as CartesianComplexString,
    );
  }
}

extension CartesianComplexStringValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CartesianComplexString, $Out> {
  CartesianComplexStringCopyWith<$R, CartesianComplexString, $Out>
  get $asCartesianComplexString => $base.as(
    (v, t, t2) => _CartesianComplexStringCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CartesianComplexStringCopyWith<
  $R,
  $In extends CartesianComplexString,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input, RealString? real, RealString? imag});
  CartesianComplexStringCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CartesianComplexStringCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CartesianComplexString, $Out>
    implements
        CartesianComplexStringCopyWith<$R, CartesianComplexString, $Out> {
  _CartesianComplexStringCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CartesianComplexString> $mapper =
      CartesianComplexStringMapper.ensureInitialized();
  @override
  $R call({String? input, RealString? real, RealString? imag}) => $apply(
    FieldCopyWithData({
      if (input != null) #input: input,
      if (real != null) #real: real,
      if (imag != null) #imag: imag,
    }),
  );
  @override
  CartesianComplexString $make(CopyWithData data) => CartesianComplexString(
    data.get(#input, or: $value.input),
    data.get(#real, or: $value.real),
    data.get(#imag, or: $value.imag),
  );

  @override
  CartesianComplexStringCopyWith<$R2, CartesianComplexString, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CartesianComplexStringCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PolarComplexStringMapper extends ClassMapperBase<PolarComplexString> {
  PolarComplexStringMapper._();

  static PolarComplexStringMapper? _instance;
  static PolarComplexStringMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PolarComplexStringMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PolarComplexString';

  static String _$input(PolarComplexString v) => v.input;
  static const Field<PolarComplexString, String> _f$input = Field(
    'input',
    _$input,
  );
  static RealString _$radius(PolarComplexString v) => v.radius;
  static const Field<PolarComplexString, RealString> _f$radius = Field(
    'radius',
    _$radius,
  );
  static RealString _$theta(PolarComplexString v) => v.theta;
  static const Field<PolarComplexString, RealString> _f$theta = Field(
    'theta',
    _$theta,
  );

  @override
  final MappableFields<PolarComplexString> fields = const {
    #input: _f$input,
    #radius: _f$radius,
    #theta: _f$theta,
  };

  static PolarComplexString _instantiate(DecodingData data) {
    return PolarComplexString(
      data.dec(_f$input),
      data.dec(_f$radius),
      data.dec(_f$theta),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PolarComplexString fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PolarComplexString>(map);
  }

  static PolarComplexString fromJson(String json) {
    return ensureInitialized().decodeJson<PolarComplexString>(json);
  }
}

mixin PolarComplexStringMappable {
  String toJson() {
    return PolarComplexStringMapper.ensureInitialized()
        .encodeJson<PolarComplexString>(this as PolarComplexString);
  }

  Map<String, dynamic> toMap() {
    return PolarComplexStringMapper.ensureInitialized()
        .encodeMap<PolarComplexString>(this as PolarComplexString);
  }

  PolarComplexStringCopyWith<
    PolarComplexString,
    PolarComplexString,
    PolarComplexString
  >
  get copyWith =>
      _PolarComplexStringCopyWithImpl<PolarComplexString, PolarComplexString>(
        this as PolarComplexString,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PolarComplexStringMapper.ensureInitialized().stringifyValue(
      this as PolarComplexString,
    );
  }

  @override
  bool operator ==(Object other) {
    return PolarComplexStringMapper.ensureInitialized().equalsValue(
      this as PolarComplexString,
      other,
    );
  }

  @override
  int get hashCode {
    return PolarComplexStringMapper.ensureInitialized().hashValue(
      this as PolarComplexString,
    );
  }
}

extension PolarComplexStringValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PolarComplexString, $Out> {
  PolarComplexStringCopyWith<$R, PolarComplexString, $Out>
  get $asPolarComplexString => $base.as(
    (v, t, t2) => _PolarComplexStringCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PolarComplexStringCopyWith<
  $R,
  $In extends PolarComplexString,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? input, RealString? radius, RealString? theta});
  PolarComplexStringCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PolarComplexStringCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PolarComplexString, $Out>
    implements PolarComplexStringCopyWith<$R, PolarComplexString, $Out> {
  _PolarComplexStringCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PolarComplexString> $mapper =
      PolarComplexStringMapper.ensureInitialized();
  @override
  $R call({String? input, RealString? radius, RealString? theta}) => $apply(
    FieldCopyWithData({
      if (input != null) #input: input,
      if (radius != null) #radius: radius,
      if (theta != null) #theta: theta,
    }),
  );
  @override
  PolarComplexString $make(CopyWithData data) => PolarComplexString(
    data.get(#input, or: $value.input),
    data.get(#radius, or: $value.radius),
    data.get(#theta, or: $value.theta),
  );

  @override
  PolarComplexStringCopyWith<$R2, PolarComplexString, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PolarComplexStringCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

