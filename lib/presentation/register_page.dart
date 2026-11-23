import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/form_widgets.dart';
import 'guias_page.dart';

class RegisterPage extends StatefulWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const RegisterPage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with FormHelper<RegisterPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nome, _email, _senha, _confirmar]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_nome.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _senha.text.isEmpty) {
      return erro('Preencha nome, e-mail e senha.');
    }
    if (_senha.text != _confirmar.text) return erro('As senhas não coincidem.');

    await executar(() async {
      await widget.authRepository.register(
        email: _email.text.trim(),
        password: _senha.text,
        name: _nome.text.trim(),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GuiasPage(
            authRepository: widget.authRepository,
            familyRepository: widget.familyRepository,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TelaComPainel(
      fundo: kAzul,
      painel: kFundo,
      flexTopo: 1,
      flexPainel: 4,
      topo: Image.asset('assets/images/logoBranca.png', width: 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Criar conta',
            style: TextStyle(
                color: kAzul, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CampoTexto(rotulo: 'Nome', dica: 'Digite seu nome', controller: _nome),
          CampoTexto(
            rotulo: 'E-mail',
            dica: 'Digite seu e-mail',
            controller: _email,
            teclado: TextInputType.emailAddress,
          ),
          CampoTexto(
            rotulo: 'Senha',
            dica: 'Crie sua senha',
            controller: _senha,
            senha: true,
          ),
          CampoTexto(
            rotulo: 'Confirmar senha',
            dica: 'Confirme sua senha',
            controller: _confirmar,
            senha: true,
          ),
          const SizedBox(height: 8),
          Botao(
              texto: 'Cadastrar', onPressed: _cadastrar, carregando: carregando),
          const SizedBox(height: 16),
          LinkTexto(
            texto: 'Já possui uma conta? ',
            destaque: 'Faça o login',
            cor: Colors.black54,
            corDestaque: kAzul,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}