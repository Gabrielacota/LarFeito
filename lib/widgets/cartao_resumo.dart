import 'package:flutter/material.dart';

class CartaoResumo extends StatelessWidget {
  const CartaoResumo({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.icone,
    required this.fundo,
    required this.corIcone,
  });

  final String rotulo, valor;
  final IconData icone;
  final Color fundo, corIcone;

  static const _azulEscuro = Color(0xFF1C2B5D);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 6,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: corIcone, size: 24),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _azulEscuro,
            ),
          ),
          Text(
            rotulo,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _azulEscuro,
            ),
          ),
        ],
      ),
    );
  }
}