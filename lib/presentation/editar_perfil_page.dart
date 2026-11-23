import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/form_widgets.dart';
import '../domain/validador_perfil.dart';
import 'avatar_perfil.dart';
import 'gerar_codigo_page.dart';
import 'sucesso_perfil_page.dart';

/// (leitura e gravação do perfil).
class PerfilService {
  final _db = FirebaseFirestore.instance;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>?> carregar() async {
    final id = uid;
    if (id == null) return null;
    return (await _db.collection('users').doc(id).get()).data();
  }

  Future<void> salvar(Map<String, dynamic> dados) async {
    final id = uid;
    if (id == null) throw Exception('Sessão expirada. Faça login novamente.');
    await _db.collection('users').doc(id).set(dados, SetOptions(merge: true));
  }
}

class EditarPerfilPage extends StatefulWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;
  final String? userEmail;

  const EditarPerfilPage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
    this.userEmail,
  });

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage>
    with FormHelper<EditarPerfilPage> {
  static const _membros = [
    'Pai', 'Mãe', 'Filho(a)', 'Primo(a)', 'Avô/Avó', 'Tio(a)', 'Outro',
  ];

  final _service = PerfilService();
  final _nome = TextEditingController();
  final _idade = TextEditingController();
  final _membroOutro = TextEditingController();
  final _codigo = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();

  bool _codigoGerado = false;
  String? _avatar, _membro, _codigoSalvo;

  @override
  void initState() {
    super.initState();
    _preencher();
  }

  @override
  void dispose() {
    for (final c in [_nome, _idade, _membroOutro, _codigo, _senha, _confirmar]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _preencher() async {
    try {
      final d = await _service.carregar();
      if (d == null || !mounted) return;
      setState(() {
        _nome.text = d['username'] ?? '';
        _idade.text = d['idade']?.toString() ?? '';
        _codigo.text = _codigoSalvo = d['codigoFamilia'] ?? '';
        _avatar = d['avatar'];
        final m = d['membroFamiliar'] as String?;
        if (m != null && m.isNotEmpty) {
          _membro = _membros.contains(m) ? m : 'Outro';
          if (_membro == 'Outro') _membroOutro.text = m;
        }
      });
    } catch (_) {}
  }

  Future<void> _abrirGerarCodigo() async {
    final codigo = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => GerarCodigoPage(
          authRepository: widget.authRepository,
          familyRepository: widget.familyRepository,
        ),
      ),
    );
    if (codigo != null && codigo.isNotEmpty) {
      setState(() {
        _codigo.text = codigo;
        _codigoGerado = true;
      });
    }
  }

  Future<void> _salvar() async {
    final mensagem = montarFila().validar(DadosPerfil(
      nome: _nome.text, perfil: _avatar, codigo: _codigo.text,
      senha: _senha.text, confirmarSenha: _confirmar.text,
    ));
    if (mensagem != null) return erro(mensagem);
    final codigo = _codigo.text.trim().toUpperCase();

    await executar(() async {
      if (!await widget.authRepository.verificarSenha(_senha.text)) {
        return erro('Senha incorreta! Digite a senha atual da sua conta.');
      }

      if (!_codigoGerado && codigo != _codigoSalvo) {
        await widget.familyRepository.entrarNaFamilia(codigo);
      }
      await _service.salvar({
        'username': _nome.text.trim(),
        'idade': int.tryParse(_idade.text.trim()),
        'membroFamiliar':
        _membro == 'Outro' ? _membroOutro.text.trim() : _membro,
        'codigoFamilia': codigo,
        'avatar': _avatar,
      });
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SucessoPerfilPage(
            authRepository: widget.authRepository,
            familyRepository: widget.familyRepository,
          ),
        ),
      );
    });
  }

  Widget _topoAvatares() {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escolha seu avatar',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final a in avataresDisponiveis)
                  GestureDetector(
                    onTap: () => setState(() => _avatar = a.id),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _avatar == a.id
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Opacity(
                        opacity: _avatar == null || _avatar == a.id ? 1 : 0.6,
                        child: AvatarPerfil(avatarId: a.id, raio: 27),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TelaComPainel(
      fundo: kAzul,
      painel: Colors.white,
      topo: _topoAvatares(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editar Perfil',
            style: TextStyle(
                color: kAzul, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          CampoTexto(rotulo: 'Username', dica: 'Digite seu nome', controller: _nome),
          CampoTexto(
            rotulo: 'Idade',
            dica: 'Digite sua idade',
            controller: _idade,
            teclado: TextInputType.number,
          ),
          const Text('Membro familiar',
              style: TextStyle(color: Colors.black54, fontSize: 16)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _membro,
            isExpanded: true,
            dropdownColor: const Color(0xFF6585FF),
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: decoracaoCampo('Selecione o membro da família'),
            items: [
              for (final m in _membros)
                DropdownMenuItem(value: m, child: Text(m)),
            ],
            onChanged: (v) => setState(() => _membro = v),
          ),
          const SizedBox(height: 12),
          if (_membro == 'Outro')
            CampoTexto(
              rotulo: 'Qual?',
              dica: 'Qual é o membro familiar?',
              controller: _membroOutro,
            ),
          CampoTexto(
            rotulo: 'Código da Família',
            dica: 'Digite o código da família',
            controller: _codigo,
            bloqueado: _codigoGerado,
          ),
          CampoTexto(
            rotulo: 'Senha',
            dica: 'Digite sua senha de login',
            controller: _senha,
            senha: true,
          ),
          CampoTexto(
            rotulo: 'Confirmar senha',
            dica: 'Confirme sua senha',
            controller: _confirmar,
            senha: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Botao(
                  texto: 'Salvar',
                  onPressed: _salvar,
                  carregando: carregando,
                  corTexto: Colors.black87,
                  altura: 48,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Botao(
                  texto: 'Cancelar',
                  onPressed: () => Navigator.pop(context),
                  cor: const Color(0xFFFFBDBD),
                  corTexto: Colors.black87,
                  altura: 48,
                ),
              ),
            ],
          ),
          if (!_codigoGerado) ...[
            const SizedBox(height: 20),
            LinkTexto(
              texto: 'Sua família não possui código? ',
              destaque: 'Gere o código',
              cor: kAzul,
              onTap: _abrirGerarCodigo,
            ),
          ],
        ],
      ),
    );
  }
}