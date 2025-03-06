sealed class FormInputError {}

class RequiredError extends FormInputError {}

class InvalidError extends FormInputError {}

class InvalidLengthError extends FormInputError {}

class InvalidPatternError extends FormInputError {}

class InvalidEmailError extends FormInputError {}

class InvalidMatchError extends FormInputError {}

class InvalidAgeError extends FormInputError {}

class TooSmallError extends FormInputError {}

class TooLargeError extends FormInputError {}

extension FormStringRequired on String? {
  FormInputError? required({final FormInputError? error}) {
    final self = this;
    if (self == null || self == '') {
      return error ?? RequiredError();
    }
    return null;
  }
}

extension FormStringValidations on String {
  FormInputError? validatePattern({
    final FormInputError? error,
    required final RegExp pattern,
  }) {
    final self = this;
    if (!pattern.hasMatch(self)) return error ?? InvalidError();
    return null;
  }

  FormInputError? validateEmail({final FormInputError? error}) {
    final self = this;

    final isValid = RegExp(
      r"""(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""",
    ).hasMatch(self);

    if (!isValid) return error ?? InvalidEmailError();

    return null;
  }

  FormInputError? validateLength(
    final int length, {
    final FormInputError? error,
  }) {
    final self = this;
    if (self.length < length) return error ?? InvalidLengthError();
    return null;
  }

  FormInputError? validateMatch(
    final String? match, {
    final FormInputError? error,
  }) {
    final self = this;
    if (self != match) return error ?? InvalidMatchError();
    return null;
  }
}

extension FormDateValidation on DateTime {
  FormInputError? validateAge(final int age, {final FormInputError? error}) {
    final relativeDate = DateTime(year + age, month, day);

    if (DateTime.now().isBefore(relativeDate)) {
      return error ?? InvalidAgeError();
    }
    return null;
  }
}

extension FormDateRequiredValidation on DateTime? {
  FormInputError? required({final FormInputError? error}) {
    if (this == null) return error ?? RequiredError();
    return null;
  }
}

extension FormIntRequired on num? {
  FormInputError? required({final FormInputError? error}) {
    final self = this;
    if (self == null) {
      return error ?? RequiredError();
    }
    return null;
  }
}

extension FormIntValidations on num {
  FormInputError? validateMax(
    final num max, {
    final FormInputError? error,
    final bool inclusive = false,
  }) {
    final exceedsMax = inclusive ? this >= max : this > max;
    if (exceedsMax) {
      return error ?? TooLargeError();
    }
    return null;
  }

  FormInputError? validateMin(
    final num min, {
    final FormInputError? error,
    final bool inclusive = false,
  }) {
    final belowMin = inclusive ? this <= min : this < min;
    if (belowMin) {
      return error ?? TooSmallError();
    }
    return null;
  }
}
