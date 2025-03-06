// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_input.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FormInputModel<T> {
  T? get value => throw _privateConstructorUsedError;
  FormInputError? get errorOverride => throw _privateConstructorUsedError;
  T? get matchValue => throw _privateConstructorUsedError;
  MatchValidator<T>? get matchValidator => throw _privateConstructorUsedError;
  FormInputStatus get status => throw _privateConstructorUsedError;
  Validator<T>? get validator => throw _privateConstructorUsedError;

  /// Create a copy of FormInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormInputModelCopyWith<T, FormInputModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormInputModelCopyWith<T, $Res> {
  factory $FormInputModelCopyWith(
          FormInputModel<T> value, $Res Function(FormInputModel<T>) then) =
      _$FormInputModelCopyWithImpl<T, $Res, FormInputModel<T>>;
  @useResult
  $Res call(
      {T? value,
      FormInputError? errorOverride,
      T? matchValue,
      MatchValidator<T>? matchValidator,
      FormInputStatus status,
      Validator<T>? validator});
}

/// @nodoc
class _$FormInputModelCopyWithImpl<T, $Res, $Val extends FormInputModel<T>>
    implements $FormInputModelCopyWith<T, $Res> {
  _$FormInputModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? errorOverride = freezed,
    Object? matchValue = freezed,
    Object? matchValidator = freezed,
    Object? status = null,
    Object? validator = freezed,
  }) {
    return _then(_value.copyWith(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      errorOverride: freezed == errorOverride
          ? _value.errorOverride
          : errorOverride // ignore: cast_nullable_to_non_nullable
              as FormInputError?,
      matchValue: freezed == matchValue
          ? _value.matchValue
          : matchValue // ignore: cast_nullable_to_non_nullable
              as T?,
      matchValidator: freezed == matchValidator
          ? _value.matchValidator
          : matchValidator // ignore: cast_nullable_to_non_nullable
              as MatchValidator<T>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FormInputStatus,
      validator: freezed == validator
          ? _value.validator
          : validator // ignore: cast_nullable_to_non_nullable
              as Validator<T>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormInputModelImplCopyWith<T, $Res>
    implements $FormInputModelCopyWith<T, $Res> {
  factory _$$FormInputModelImplCopyWith(_$FormInputModelImpl<T> value,
          $Res Function(_$FormInputModelImpl<T>) then) =
      __$$FormInputModelImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {T? value,
      FormInputError? errorOverride,
      T? matchValue,
      MatchValidator<T>? matchValidator,
      FormInputStatus status,
      Validator<T>? validator});
}

/// @nodoc
class __$$FormInputModelImplCopyWithImpl<T, $Res>
    extends _$FormInputModelCopyWithImpl<T, $Res, _$FormInputModelImpl<T>>
    implements _$$FormInputModelImplCopyWith<T, $Res> {
  __$$FormInputModelImplCopyWithImpl(_$FormInputModelImpl<T> _value,
      $Res Function(_$FormInputModelImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of FormInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? errorOverride = freezed,
    Object? matchValue = freezed,
    Object? matchValidator = freezed,
    Object? status = null,
    Object? validator = freezed,
  }) {
    return _then(_$FormInputModelImpl<T>(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      errorOverride: freezed == errorOverride
          ? _value.errorOverride
          : errorOverride // ignore: cast_nullable_to_non_nullable
              as FormInputError?,
      matchValue: freezed == matchValue
          ? _value.matchValue
          : matchValue // ignore: cast_nullable_to_non_nullable
              as T?,
      matchValidator: freezed == matchValidator
          ? _value.matchValidator
          : matchValidator // ignore: cast_nullable_to_non_nullable
              as MatchValidator<T>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FormInputStatus,
      validator: freezed == validator
          ? _value.validator
          : validator // ignore: cast_nullable_to_non_nullable
              as Validator<T>?,
    ));
  }
}

/// @nodoc

class _$FormInputModelImpl<T> extends _FormInputModel<T> {
  const _$FormInputModelImpl(
      {this.value,
      this.errorOverride,
      this.matchValue,
      this.matchValidator,
      this.status = FormInputStatus.pure,
      this.validator})
      : super._();

  @override
  final T? value;
  @override
  final FormInputError? errorOverride;
  @override
  final T? matchValue;
  @override
  final MatchValidator<T>? matchValidator;
  @override
  @JsonKey()
  final FormInputStatus status;
  @override
  final Validator<T>? validator;

  @override
  String toString() {
    return 'FormInputModel<$T>(value: $value, errorOverride: $errorOverride, matchValue: $matchValue, matchValidator: $matchValidator, status: $status, validator: $validator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormInputModelImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.errorOverride, errorOverride) ||
                other.errorOverride == errorOverride) &&
            const DeepCollectionEquality()
                .equals(other.matchValue, matchValue) &&
            (identical(other.matchValidator, matchValidator) ||
                other.matchValidator == matchValidator) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.validator, validator) ||
                other.validator == validator));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(value),
      errorOverride,
      const DeepCollectionEquality().hash(matchValue),
      matchValidator,
      status,
      validator);

  /// Create a copy of FormInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormInputModelImplCopyWith<T, _$FormInputModelImpl<T>> get copyWith =>
      __$$FormInputModelImplCopyWithImpl<T, _$FormInputModelImpl<T>>(
          this, _$identity);
}

abstract class _FormInputModel<T> extends FormInputModel<T> {
  const factory _FormInputModel(
      {final T? value,
      final FormInputError? errorOverride,
      final T? matchValue,
      final MatchValidator<T>? matchValidator,
      final FormInputStatus status,
      final Validator<T>? validator}) = _$FormInputModelImpl<T>;
  const _FormInputModel._() : super._();

  @override
  T? get value;
  @override
  FormInputError? get errorOverride;
  @override
  T? get matchValue;
  @override
  MatchValidator<T>? get matchValidator;
  @override
  FormInputStatus get status;
  @override
  Validator<T>? get validator;

  /// Create a copy of FormInputModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormInputModelImplCopyWith<T, _$FormInputModelImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
