String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&^])[A-Za-z\d@$!%*?#&^]{8,}$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must be 8+ characters, include upper/lowercase,\na number, and a special character';
  }
  return null;
}
