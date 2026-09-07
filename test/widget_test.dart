import 'package:flutter_test/flutter_test.dart';
import 'package:lar_feito/auth_repository.dart';
import 'package:lar_feito/main.dart';

// Implementação falsa do repositório apenas para execução dos testes
class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({required String email, required String password}) async {}
}

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    final fakeAuthRepository = FakeAuthRepository();

    // Passamos o repositório falso para o MyApp
    await tester.pumpWidget(MyApp(authRepository: fakeAuthRepository));
  });
}