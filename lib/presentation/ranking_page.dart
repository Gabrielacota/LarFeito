import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'avatar_perfil.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  static const _azulEscuro = Color(0xFF1C2B5D);
  static const _azul = Color(0xFF5D7FFF);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFE6E9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _azulEscuro),
        title: const Text(
          'Ranking da Família',
          style: TextStyle(color: _azulEscuro, fontWeight: FontWeight.bold),
        ),
      ),
      body: uid == null
          ? const _Mensagem('Faça login para ver o ranking.')
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, meuSnap) {
          if (!meuSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final familyId = meuSnap.data?.data()?['familyId'] as String?;
          if (familyId == null || familyId.isEmpty) {
            return const _Mensagem(
              'Você ainda não está em uma família.\n'
                  'Informe ou gere um código no seu perfil.',
            );
          }
          return _ListaRanking(familyId: familyId, meuUid: uid);
        },
      ),
    );
  }
}

class _ListaRanking extends StatelessWidget {
  final String familyId;
  final String meuUid;

  const _ListaRanking({required this.familyId, required this.meuUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('familyId', isEqualTo: familyId)
          .snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return _Mensagem('Não foi possível carregar o ranking.\n${snap.error}');
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final membros = snap.data!.docs.map((d) {
          final m = d.data();

          // Membro familiar cadastrado no Firestore (mesmos campos da tela Início)
          final String? membroSalvo =
              (m['membroFamiliar'] as String?) ?? (m['membro'] as String?);

          return _Membro(
            uid: d.id,
            nome: (m['username'] as String?)?.trim().isNotEmpty == true
                ? m['username'] as String
                : 'Usuário',
            membroFamiliar:
            (membroSalvo != null && membroSalvo.trim().isNotEmpty)
                ? membroSalvo
                : 'Membro da Família',
            nivel: (m['nivel'] as String?) ?? 'Nível 1 • Iniciante',
            avatar: m['avatar'] as String?,
            pontos: (m['pontos'] as num?)?.toInt() ?? 0,
          );
        }).toList()
        // Ordena aqui no app, para não precisar criar índice no Firestore
          ..sort((a, b) {
            final porPontos = b.pontos.compareTo(a.pontos);
            return porPontos != 0 ? porPontos : a.nome.compareTo(b.nome);
          });

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: membros.length,
          itemBuilder: (context, i) => _CartaoMembro(
            posicao: i + 1,
            membro: membros[i],
            souEu: membros[i].uid == meuUid,
          ),
        );
      },
    );
  }
}

class _Membro {
  final String uid;
  final String nome;
  final String membroFamiliar;
  final String nivel;
  final String? avatar;
  final int pontos;

  const _Membro({
    required this.uid,
    required this.nome,
    required this.membroFamiliar,
    required this.nivel,
    required this.avatar,
    required this.pontos,
  });
}

class _CartaoMembro extends StatelessWidget {
  final int posicao;
  final _Membro membro;
  final bool souEu;

  const _CartaoMembro({
    required this.posicao,
    required this.membro,
    required this.souEu,
  });

  static const _medalhas = {
    1: Color(0xFFFFC107),
    2: Color(0xFF9E9E9E),
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final medalha = _medalhas[posicao];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: souEu ? RankingPage._azul : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medalha != null
                ? Icon(Icons.emoji_events, color: medalha, size: 28)
                : Text(
              '$posicaoº',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: RankingPage._azulEscuro,
              ),
            ),
          ),
          const SizedBox(width: 10),
          AvatarPerfil(avatarId: membro.avatar, raio: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  souEu ? '${membro.nome} (você)' : membro.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: RankingPage._azulEscuro,
                  ),
                ),
                Text(
                  membro.membroFamiliar,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  membro.nivel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${membro.pontos} pts',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: RankingPage._azul,
            ),
          ),
        ],
      ),
    );
  }
}

class _Mensagem extends StatelessWidget {
  final String texto;
  const _Mensagem(this.texto);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54, fontSize: 15),
        ),
      ),
    );
  }
}