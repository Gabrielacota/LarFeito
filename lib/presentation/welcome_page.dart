import 'package:flutter/material.dart';
import 'package:lar_feito/widgets/fundo_decorativo.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const WelcomePage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  @override
  Widget build(BuildContext context) {
    return FundoDecorativo(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36, 0, 36, 100),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          authRepository: authRepository,
                          familyRepository: familyRepository,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8FFA8),
                    foregroundColor: const Color(0xFF7B82DD),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Começar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_right_alt, size: 34),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}