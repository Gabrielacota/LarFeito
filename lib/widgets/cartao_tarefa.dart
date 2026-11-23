import 'package:flutter/material.dart';

/// Quadradinho de tarefa (ícone + título + seta).
/// Reutilizável: na Início, na tela de Tarefas, em qualquer lista de afazeres.
/// Passe [onTap] para abrir os detalhes da tarefa.
class CartaoTarefa extends StatelessWidget {
  const CartaoTarefa({
    super.key,
    required this.titulo,
    required this.icone,
    this.onTap,
  });

  final String titulo;
  final IconData icone;
  final VoidCallback? onTap;

  static const _azulEscuro = Color(0xFF1C2B5D);

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(16);
    return Material(
      color: const Color(0xFFF0F3FA),
      borderRadius: borda,
      child: InkWell(
        borderRadius: borda,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            spacing: 8,
            children: [
              Icon(icone, color: _azulEscuro, size: 24),
              Expanded(
                child: Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _azulEscuro,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: _azulEscuro, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}