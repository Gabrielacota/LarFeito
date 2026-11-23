import 'package:flutter/material.dart';

class AvatarOpcao {
  final String id;
  final String asset;
  final Color cor;
  final IconData icone;

  const AvatarOpcao(this.id, this.asset, this.cor, this.icone);
}

const List<AvatarOpcao> avataresDisponiveis = [
  AvatarOpcao('avatar1', 'assets/images/avatar1.png', Color(0xFF5D7FFF), Icons.pets),
  AvatarOpcao('avatar2', 'assets/images/avatar2.png', Color(0xFF4CAF50), Icons.eco),
  AvatarOpcao('avatar3', 'assets/images/avatar3.png', Color(0xFFFFB74D), Icons.wb_sunny),
  AvatarOpcao('avatar4', 'assets/images/avatar4.png', Color(0xFFE57373), Icons.favorite),
];

AvatarOpcao? avatarPorId(String? id) {
  for (final a in avataresDisponiveis) {
    if (a.id == id) return a;
  }
  return null;
}

class AvatarPerfil extends StatelessWidget {
  final String? avatarId;
  final double raio;

  const AvatarPerfil({super.key, required this.avatarId, this.raio = 20});

  @override
  Widget build(BuildContext context) {
    final opcao = avatarPorId(avatarId);

    if (opcao == null) {
      return CircleAvatar(
        radius: raio,
        backgroundColor: const Color(0xFF90A4AE),
        child: Icon(Icons.person, color: Colors.white, size: raio),
      );
    }

    return CircleAvatar(
      radius: raio,
      backgroundColor: opcao.cor,
      child: ClipOval(
        child: Image.asset(
          opcao.asset,
          width: raio * 2,
          height: raio * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(opcao.icone, color: Colors.white, size: raio),
        ),
      ),
    );
  }
}