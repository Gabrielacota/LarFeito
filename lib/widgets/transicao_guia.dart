import 'package:flutter/material.dart';
import 'balao_fala.dart';
import 'fundo_decorativo.dart';

/// Dados de UM guia: o texto do balão, a imagem da arara e (opcional) um botão.
class GuiaSlide {
  const GuiaSlide({
    required this.texto,
    required this.imagem,
    this.alturaImagem = 260,
    this.botao,
  });

  final List<TextSpan> texto;
  final String imagem;
  final double alturaImagem;
  final Widget? botao;
}

class TransicaoGuia extends StatefulWidget {
  const TransicaoGuia({super.key, required this.slides});

  final List<GuiaSlide> slides;

  @override
  State<TransicaoGuia> createState() => _TransicaoGuiaState();
}

class _TransicaoGuiaState extends State<TransicaoGuia> {
  final _controller = PageController();
  int _atual = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _irPara(int i) => _controller.animateToPage(
    i,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  Widget _indicador() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.slides.length; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _irPara(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _atual ? 16 : 12,
                height: i == _atual ? 16 : 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _atual
                      ? const Color(0xFF5D7FFF)
                      : const Color(0xFFB8CFFE),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _slide(GuiaSlide s) {
    return Column(
      children: [
        const Spacer(),
        BalaoFala(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF2B3A67),
              ),
              children: s.texto,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Image.asset(s.imagem, height: s.alturaImagem, fit: BoxFit.contain),
        if (s.botao == null)
          const Spacer()
        else ...[
          const SizedBox(height: 24),
          s.botao!,
          const SizedBox(height: 30),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FundoDecorativo(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _indicador(),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _atual = i),
                  children: [for (final s in widget.slides) _slide(s)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}