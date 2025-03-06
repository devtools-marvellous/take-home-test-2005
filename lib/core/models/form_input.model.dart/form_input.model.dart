import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_home_marv/core/extensions/validation.dart';

part 'form_input.model.freezed.dart';

enum FormInputStatus {
  pure,
  dirty,
}

typedef Validator<T> = FormInputError? Function(T?);

typedef MatchValidator<T> = FormInputError? Function(T?, T?);

class JsonStringConverter
    implements JsonConverter<FormInputModel<String>, String> {
  /// {@macro jsonStringConverter}
  const JsonStringConverter();

  @override
  FormInputModel<String> fromJson(final String json) =>
      FormInputModel<String>(value: json);

  @override
  String toJson(final FormInputModel<String> object) => object.value ?? '';
}

@freezed
class FormInputModel<T> with _$FormInputModel<T> {
  const factory FormInputModel({
    final T? value,
    final FormInputError? errorOverride,
    final T? matchValue,
    final MatchValidator<T>? matchValidator,
    @Default(FormInputStatus.pure) final FormInputStatus status,
    final Validator<T>? validator,
  }) = _FormInputModel<T>;
  const FormInputModel._();

  bool get isPure => status == FormInputStatus.pure;
  bool get hasMatch => value == matchValue;
  FormInputModel<T> setDirty() => copyWith(status: FormInputStatus.dirty);
  FormInputError? get error {
    if (errorOverride != null) return errorOverride;
    if ((validator == null && matchValidator == null) || isPure) return null;
    FormInputError? validatorError;
    FormInputError? matchError;
    if (validator != null) validatorError = validator!(value);
    if (matchValidator != null) matchError = matchValidator!(value, matchValue);
    return matchError ?? validatorError;
  }
}
