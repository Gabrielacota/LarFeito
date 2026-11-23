import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'domain/auth_repository.dart';
import 'domain/family_repository.dart';
import 'data/firebase_auth_repository.dart';
import 'data/firestore_family_repository.dart';
import 'data/firebase_options.dart';
import 'presentation/inicio_page.dart';
import 'presentation/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //funcionamento offline
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // Injeção de dependência
  final AuthRepository authRepository = FirebaseAuthRepository();
  final FamilyRepository familyRepository = FirestoreFamilyRepository();

  await authRepository.sessaoValida();

  runApp(MyApp(
    authRepository: authRepository,
    familyRepository: familyRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Sessão persistente
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.data == null) {
            return WelcomePage(
              authRepository: authRepository,
              familyRepository: familyRepository,
            );
          }
          return InicioPage(
            authRepository: authRepository,
            familyRepository: familyRepository,
          );
        },
      ),
    );
  }
}