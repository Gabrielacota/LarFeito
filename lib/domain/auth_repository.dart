abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<bool> sessaoValida();

  Future<void> register({
    required String email,
    required String password,
    String? name,
  });

  Future<bool> verificarSenha(String password);
  Future<void> recuperarSenha(String email);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}