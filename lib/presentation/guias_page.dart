import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/form_widgets.dart';
import '../widgets/transicao_guia.dart';
import 'editar_perfil_page.dart';

class GuiasPage extends StatelessWidget {
  const GuiasPage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  static const _negrito = TextStyle(fontWeight: FontWeight.bold);
  static const _destaque =
  TextStyle(fontWeight: FontWeight.bold, color: kAzul);

  static const _boasVindas = [
    TextSpan(text: 'Seja bem-vindo a jornada em família: ', style: _negrito),
    TextSpan(text: 'LarFeito', style: _destaque),
    TextSpan(text: '!\nAqui, cada conquista é mais leve quando é compartilhada.'),
  ];

  @override
  Widget build(BuildContext context) {
    return TransicaoGuia(
      slides: [
        const GuiaSlide(
          texto: _boasVindas,
          imagem: 'assets/images/ararinhaInicia.png',
        ),
        const GuiaSlide(
          texto: _boasVindas, // TODO: trocar pelo texto do guia 2
          imagem: 'assets/images/ararinhaFala.png',
        ),
        GuiaSlide(
          texto: const [
            TextSpan(text: 'Deixe seu perfil com a sua cara! Escolha um '),
            TextSpan(text: 'avatar', style: _destaque),
            TextSpan(text: ' e complete '),
            TextSpan(text: 'seu perfil', style: _destaque),
            TextSpan(text: '.'),
          ],
          imagem: 'assets/images/ararinhaVoa.png',
          alturaImagem: 230,
          botao: Botao(
            texto: 'Personalizar meu perfil',
            icone: Icons.arrow_forward,
            altura: 58,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditarPerfilPage(
                  authRepository: authRepository,
                  familyRepository: familyRepository,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}