import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lar_feito/domain/auth_repository.dart';
import 'package:lar_feito/domain/family_repository.dart';
import 'package:lar_feito/presentation/welcome_page.dart';

// Repositórios falsos
class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {}

  @override
  Future<bool> verificarSenha(String password) async => true;

  @override
  Future<bool> sessaoValida() async => true;

  @override
  Future<void> recuperarSenha(String email) async {}
}

class FakeFamilyRepository implements FamilyRepository {
  @override
  String gerarCodigo() => 'LF-TESTE1';

  @override
  Future<void> criarFamilia(String codigo) async {}

  @override
  Future<void> entrarNaFamilia(String codigo) async {}
}

void main() {
  testWidgets('WelcomePage carrega sem Firebase', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WelcomePage(
        authRepository: FakeAuthRepository(),
        familyRepository: FakeFamilyRepository(),
      ),
    ));

    expect(find.text('Começar'), findsOneWidget);
  });
}