class MockAuthService {
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return email.isNotEmpty && password.isNotEmpty;
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  static String currentUserEmail() => "demo_user@resumate.app";
}
