import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/cabecalho_perfil.dart';
import '../widgets/cartao_resumo.dart';
import '../widgets/cartao_secao.dart';
import '../widgets/cartao_tarefa.dart';
import 'ranking_page.dart';

class InicioPage extends StatefulWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const InicioPage({
    super.key,
    required this.authRepository,
    required this.familyRepository,
  });

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _indice = 0;

  static const _metricas = [
    ('Atribuídas', '2', Icons.access_time_rounded, Color(0xFFEDEBFD), Color(0xFF5D7FFF)),
    ('Concluídas', '0', Icons.check_rounded, Color(0xFFE8F8EE), Color(0xFF4CAF50)),
    ('Pendentes', '1', Icons.close_rounded, Color(0xFFFDEEEF), Color(0xFFE57373)),
  ];

  static const _tarefas = [
    ('Varrer a casa', Icons.cleaning_services_outlined),
    ('Dobrar roupas', Icons.local_laundry_service_outlined),
    ('Lavar louça', Icons.local_cafe_outlined),
    ('Passear com o pet', Icons.pets_outlined),
  ];

  void _aoTocarMenu(int i) {
    // Ranking abre em tela própria; o menu continua em "Início".
    if (i == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const RankingPage()));
    } else {
      setState(() => _indice = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CabecalhoPerfil(),
              ),
              Image.asset(
                'assets/images/ararinhaTopo.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              CartaoSecao(
                icone: Icons.bar_chart_rounded,
                titulo: 'Visão Geral',
                child: Row(
                  spacing: 10,
                  children: [
                    for (final (rotulo, valor, icone, fundo, cor) in _metricas)
                      Expanded(
                        child: CartaoResumo(
                          rotulo: rotulo,
                          valor: valor,
                          icone: icone,
                          fundo: fundo,
                          corIcone: cor,
                        ),
                      ),
                  ],
                ),
              ),
              CartaoSecao(
                icone: Icons.assignment_outlined,
                titulo: 'Lista de Tarefas Domiciliares',
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.9,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    for (final (titulo, icone) in _tarefas)
                      CartaoTarefa(titulo: titulo, icone: icone, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarraNavegacao(indice: _indice, onTap: _aoTocarMenu),
    );
  }
}