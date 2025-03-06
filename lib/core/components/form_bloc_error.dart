import 'package:flutter/material.dart';

class FormBlocError extends StatelessWidget {
  static const double errorHeight = 23;
  final double? textHeight;
  final Alignment alignment;

  final String? text;
  const FormBlocError({
    super.key,
    required this.text,
    this.alignment = Alignment.centerLeft,
    this.textHeight = FormBlocError.errorHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: alignment,
      child: Text(
        text ?? '',
        style: theme.textTheme.bodySmall!.copyWith(color: Colors.red),
      ),
    );
  }
}
