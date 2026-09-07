abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}