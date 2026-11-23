import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/family_repository.dart';

class FirestoreFamilyRepository implements FamilyRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreFamilyRepository({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  // Sem (0/O, 1/I)
  static const _caracteres = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  @override
  String gerarCodigo() {
    final random = Random.secure();
    final sufixo = List.generate(
      6,
          (_) => _caracteres[random.nextInt(_caracteres.length)],
    ).join();
    return 'LF-$sufixo';
  }

  @override
  Future<void> criarFamilia(String codigo) async {
    final uid = _uidDoUsuarioLogado();
    final familiaRef = _db.collection('families').doc(codigo.trim().toUpperCase());
    final usuarioRef = _db.collection('users').doc(uid);

    try {

      final criou = await _db.runTransaction<bool>((transacao) async {
        final familia = await transacao.get(familiaRef);
        if (familia.exists) return false; // código já usado

        transacao.set(familiaRef, {
          'members': [uid],
          'createdBy': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transacao.set(usuarioRef, {'familyId': familiaRef.id}, SetOptions(merge: true));
        return true;
      });

      if (!criou) {
        throw const FamilyException('Esse código já existe. Gere outro.');
      }
    } on FirebaseException catch (e) {
      throw FamilyException(_mensagemDeErro(e));
    }
  }

  @override
  Future<void> entrarNaFamilia(String codigo) async {
    final uid = _uidDoUsuarioLogado();
    final familiaRef = _db.collection('families').doc(codigo.trim().toUpperCase());
    final usuarioRef = _db.collection('users').doc(uid);

    try {
      final entrou = await _db.runTransaction<bool>((transacao) async {
        final familia = await transacao.get(familiaRef);
        if (!familia.exists) return false; // código não existe

        final membros = List<String>.from(familia.data()?['members'] ?? []);
        if (!membros.contains(uid)) {
          // arrayUnion nunca duplica o mesmo uid na lista.
          transacao.update(familiaRef, {
            'members': FieldValue.arrayUnion([uid]),
          });
        }
        transacao.set(usuarioRef, {'familyId': familiaRef.id}, SetOptions(merge: true));
        return true;
      });

      if (!entrou) {
        throw const FamilyException('Código de família não encontrado.');
      }
    } on FirebaseException catch (e) {
      throw FamilyException(_mensagemDeErro(e));
    }
  }

  String _uidDoUsuarioLogado() {
    final usuario = _auth.currentUser;
    if (usuario == null) {
      throw const FamilyException('Você precisa estar logado.');
    }
    return usuario.uid;
  }

  String _mensagemDeErro(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Você não tem permissão para fazer isso.';
      case 'unavailable':
        return 'Sem conexão com a internet. Tente novamente.';
      default:
        return e.message ?? 'Erro ao acessar os dados da família.';
    }
  }
}