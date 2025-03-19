enum TokenType {
  user,
  api,
  none;

  const TokenType();

  static TokenType fromString(String? stringTokenType) {
    return TokenType.values.firstWhere(
      (e) => e.name == (stringTokenType ?? 'none'),
      orElse: () => TokenType.none,
    );
  }
}
