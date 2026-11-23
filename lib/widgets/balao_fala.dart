import 'package:flutter/material.dart';

class BalaoFala extends StatelessWidget {
  const BalaoFala({
    super.key,
    required this.child,
    this.pontaEmCima = false,
    this.posicaoPonta = const Alignment(-0.6, 0.0),
    this.paddingVertical = 22,
  });


  final Widget child;
  final bool pontaEmCima;

  final Alignment posicaoPonta;

  final double paddingVertical;

  static const Color _cor = Color(0xFFD7E5FF);

  @override
  Widget build(BuildContext context) {

    final caixa = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: paddingVertical),
      decoration: BoxDecoration(
        color: _cor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );


    final ponta = Align(
      alignment: posicaoPonta,
      child: ClipPath(
        clipper: _PontaClipper(paraCima: pontaEmCima),
        child: Container(width: 24, height: 16, color: _cor),
      ),
    );


    return Column(
      children: pontaEmCima ? [ponta, caixa] : [caixa, ponta],
    );
  }
}

class _PontaClipper extends CustomClipper<Path> {
  const _PontaClipper({required this.paraCima});

  final bool paraCima;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (paraCima) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
