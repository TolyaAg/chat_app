class FieldValidators {
  static String email(value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String username(value) {
    if (value.isEmpty || value.length < 4) {
      return 'Enter at least 4 characters';
    }
    return null;
  }

  static String password(value) {
    if (value.isEmpty || value.length < 7) {
      return 'Password must be at least 7 characters';
    }
    return null;
  }
}
