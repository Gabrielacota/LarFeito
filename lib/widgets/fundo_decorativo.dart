import 'package:flutter/material.dart';

class FundoDecorativo extends StatelessWidget {
  const FundoDecorativo({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9F2),
      body: Stack(
        children: [
          const _Circulo(
            cor: Color(0xFF6DB3F2),
            tamanho: 200,
            top: -90,
            left: -70,
          ),
          const _Circulo(
            cor: Color(0x80A9CDF5),
            tamanho: 150,
            top: -60,
            left: 40,
          ),
          const _Circulo(
            cor: Color(0x80B9C4F5),
            tamanho: 160,
            top: 380,
            right: -85,
          ),
          const _Circulo(
            cor: Color(0x809AA8F0),
            tamanho: 120,
            top: 480,
            right: -80,
          ),
          const _Circulo(
            cor: Color(0xCC8FC1F2),
            tamanho: 180,
            bottom: -90,
            left: -60,
          ),
          const _Circulo(
            cor: Color(0x80A9CDF5),
            tamanho: 160,
            bottom: -100,
            left: 30,
          ),

          child,
        ],
      ),
    );
  }
}

class _Circulo extends StatelessWidget {
  const _Circulo({
    required this.cor,
    required this.tamanho,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Color cor;
  final double tamanho;
  final double? top, bottom, left, right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      ),
    );
  }
}