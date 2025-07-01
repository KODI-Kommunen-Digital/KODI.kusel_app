import 'package:flutter/cupertino.dart';
import 'package:kusel/l10n/app_localizations.dart';

String? validatePassword(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).password_required;
  }
  final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&^])[A-Za-z\d@$!%*?#&^]{8,}$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must be 8+ characters, include upper/lowercase,\na number, and a special character';
  }
  return null;
}
