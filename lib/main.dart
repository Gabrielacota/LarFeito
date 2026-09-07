import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_repository.dart';
import 'firebase_auth_repository.dart';
import 'welcome_page.dart';

void main() async {
  // Garante inicialização do Flutter antes de chamar serviços nativos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp();

  // Injeção de dependência: trocamos o InMemory pelo FirebaseAuthRepository
  final AuthRepository authRepository = FirebaseAuthRepository();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(authRepository: authRepository),
    );
  }
}