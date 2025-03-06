class TokenException implements Exception {
  /// {@macro tokenException}
  TokenException({
    this.message,
    this.prefix,
  });

  /// The error message
  final String? message;

  /// The prefix to the error
  final String? prefix;

  @override
  String toString() {
    return "$prefix$message";
  }
}

/// {@template unAuthException}
/// Extends token exception rather than api exception
/// {@endtemplate}
class UnauthorisedException extends TokenException {
  /// {@macro unAuthException}
  UnauthorisedException({
    super.message,
  }) : super(prefix: 'Unauthorised: ');
}
