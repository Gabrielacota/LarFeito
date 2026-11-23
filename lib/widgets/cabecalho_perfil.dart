import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../presentation/avatar_perfil.dart';

const _azulEscuro = Color(0xFF1C2B5D);

final _sombra = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
];

String _texto(dynamic v, String padrao) =>
    v is String && v.trim().isNotEmpty ? v : padrao;

class CabecalhoPerfil extends StatelessWidget {
  const CabecalhoPerfil({super.key, this.onConfiguracoes});

  final VoidCallback? onConfiguracoes;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? _stream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _stream(),
      builder: (context, snap) {
        final d = snap.data?.data();
        return Row(
          spacing: 12,
          children: [
            Flexible(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _sombra,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    AvatarPerfil(avatarId: d?['avatar'] as String?, raio: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _texto(d?['username'], 'Usuário'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _azulEscuro,
                            ),
                          ),
                          Text(
                            _texto(d?['membroFamiliar'] ?? d?['membro'],
                                'Membro da Família'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: _sombra,
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: _azulEscuro),
                onPressed: onConfiguracoes,
              ),
            ),
          ],
        );
      },
    );
  }
}