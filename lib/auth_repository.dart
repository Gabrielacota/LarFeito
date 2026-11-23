abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}