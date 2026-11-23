import 'package:firebase_auth/firebase_auth.dart';
import '../domain/auth_repository.dart';
import 'dart:async';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  @override
  Future<bool> sessaoValida() async {
    final usuario = _firebaseAuth.currentUser;
    if (usuario == null) return false;
    try {

      await usuario.reload().timeout(const Duration(seconds: 5));
      return _firebaseAuth.currentUser != null;
    } on FirebaseAuthException catch (e) {
      const contaMorta = {
        'user-not-found',
        'user-disabled',
        'user-token-expired',
        'invalid-user-token',
      };
      if (contaMorta.contains(e.code)) {
        await _firebaseAuth.signOut();
        return false;
      }
      return true;
    } on TimeoutException {
      return true;
    }
  }


  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzir(e));
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credencial = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (name != null && name.isNotEmpty) {
        await credencial.user?.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzir(e));
    }
  }

  @override
  Future<bool> verificarSenha(String password) async {
    final usuario = _firebaseAuth.currentUser;
    final email = usuario?.email;

    if (usuario == null || email == null) return false;

    try {

      await usuario.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AuthException(_traduzir(e));
      }
      return false;
    }
  }

  @override
  Future<void> recuperarSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzir(e));
    }
  }

  String _traduzir(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Já existe uma conta com esse e-mail.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente de novo.';
      default:
        return e.message ?? 'Erro de autenticação.';
    }
  }
}