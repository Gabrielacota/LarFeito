import 'package:flutter/material.dart';

class CartaoSecao extends StatelessWidget {
  const CartaoSecao({
    super.key,
    required this.icone,
    required this.titulo,
    required this.child,
    this.acao,
  });

  final IconData icone;
  final String titulo;
  final Widget child;
  final Widget? acao;

  static const _azulEscuro = Color(0xFF1C2B5D);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icone, color: _azulEscuro),
              Expanded(
                child: Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _azulEscuro,
                  ),
                ),
              ),
              if (acao != null) acao!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}