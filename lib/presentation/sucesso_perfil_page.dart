import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/fundo_decorativo.dart';
import 'inicio_page.dart';


class SucessoPerfilPage extends StatelessWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const SucessoPerfilPage(
      {super.key, required this.authRepository, required this.familyRepository});

  @override
  Widget build(BuildContext context) {
    return FundoDecorativo(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/ararinhaComemorando.png',
                height: 230,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),


              Column(
                children: [

                  Align(
                    alignment: const Alignment(-0.2, 0.0),
                    child: ClipPath(
                      clipper: _TopBubbleTailClipper(),
                      child: Container(
                        width: 24,
                        height: 14,
                        color: const Color(0xFFD7E5FF),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7E5FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Tudo certo!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C2B5D),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Seu perfil foi salvo com sucesso.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C2B5D),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2B3A67),
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Agora você já pode aproveitar tudo o que o '),
                              TextSpan(
                                text: 'Lar Feito',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D7FFF),
                                ),
                              ),
                              TextSpan(text: ' tem para você!'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Botão
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega para a InicioPage limpando o histórico anterior
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InicioPage(
                              authRepository: authRepository,
                              familyRepository: familyRepository,
                            ),
                      ),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA7FF9E),
                    foregroundColor: const Color(0xFF1C2B5D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Começar agora',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBubbleTailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}