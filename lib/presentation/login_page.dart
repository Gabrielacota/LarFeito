import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/form_widgets.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const LoginPage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with FormHelper<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_email.text.trim().isEmpty || _senha.text.isEmpty) {
      return erro('Preencha o e-mail e a senha.');
    }
    await executar(() async {
      await widget.authRepository
          .login(email: _email.text.trim(), password: _senha.text);
      if (!mounted) return;

      Navigator.of(context).popUntil((rota) => rota.isFirst);
    });
  }

  Future<void> _recuperarSenha() async {
    final email = _email.text.trim();
    if (email.isEmpty) return erro('Digite seu e-mail primeiro.');
    await executar(() async {
      await widget.authRepository.recuperarSenha(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enviamos um link para $email, se a conta existir.'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TelaComPainel(
      fundo: kFundo,
      painel: kAzul,
      flexTopo: 2,
      flexPainel: 3,
      topo: Image.asset('assets/images/logo.png', width: 230),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entrar na conta',
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CampoTexto(
            rotulo: 'E-mail',
            dica: 'Digite seu e-mail',
            controller: _email,
            teclado: TextInputType.emailAddress,
            sobreAzul: true,
          ),
          CampoTexto(
            rotulo: 'Senha',
            dica: 'Digite sua senha',
            controller: _senha,
            senha: true,
            sobreAzul: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: carregando ? null : _recuperarSenha,
              child: const Text(
                'Esqueceu a senha?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Botao(texto: 'Entrar', onPressed: _entrar, carregando: carregando),
          const SizedBox(height: 16),
          LinkTexto(
            texto: 'Ainda não possui conta? ',
            destaque: 'Cadastre-se',
            cor: Colors.white,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterPage(
                  authRepository: widget.authRepository,
                  familyRepository: widget.familyRepository,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}