import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';

const kAzul = Color(0xFF5D7FFF);
const kVerde = Color(0xFFA7FF9E);
const kFundo = Color(0xFFE6E9F2);

mixin FormHelper<T extends StatefulWidget> on State<T> {
  bool carregando = false;

  void erro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> executar(Future<void> Function() acao) async {
    setState(() => carregando = true);
    try {
      await acao();
    } on AuthException catch (e) {
      erro(e.message);
    } on FamilyException catch (e) {
      erro(e.message);
    } catch (e) {
      erro('Erro inesperado: $e');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }
}

InputDecoration decoracaoCampo(
    String dica, {
      Widget? sufixo,
      bool bloqueado = false,
      bool sobreAzul = false,
    }) =>
    InputDecoration(
      hintText: dica,
      hintStyle: TextStyle(color: sobreAzul ? Colors.grey : Colors.white70),
      filled: true,
      fillColor: sobreAzul
          ? Colors.white
          : (bloqueado ? const Color(0xFF8C9095) : const Color(0xFF6585FF)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      suffixIcon: sufixo,
    );

class CampoTexto extends StatefulWidget {
  const CampoTexto({
    super.key,
    required this.rotulo,
    required this.controller,
    required this.dica,
    this.senha = false,
    this.teclado,
    this.bloqueado = false,
    this.sobreAzul = false,
  });

  final String rotulo, dica;
  final TextEditingController controller;
  final bool senha, bloqueado, sobreAzul;
  final TextInputType? teclado;

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    final azul = widget.sobreAzul;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.rotulo,
            style: TextStyle(
              color: azul ? Colors.white : Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.controller,
            keyboardType: widget.teclado,
            readOnly: widget.bloqueado,
            obscureText: widget.senha && _oculto,
            style: TextStyle(color: azul ? Colors.black87 : Colors.white),
            decoration: decoracaoCampo(
              widget.dica,
              bloqueado: widget.bloqueado,
              sobreAzul: azul,
              sufixo: !widget.senha
                  ? null
                  : IconButton(
                icon: Icon(
                  _oculto
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: azul ? kAzul : Colors.white,
                ),
                onPressed: () => setState(() => _oculto = !_oculto),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão arredondado
class Botao extends StatelessWidget {
  const Botao({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
    this.cor = kVerde,
    this.corTexto = kAzul,
    this.altura = 52,
    this.icone,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool carregando;
  final Color cor, corTexto;
  final double altura;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: altura,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: corTexto,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: carregando
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texto,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
            if (icone != null) ...[
              const SizedBox(width: 8),
              Icon(icone, size: 24),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Já possui uma conta? **Faça o login**"
class LinkTexto extends StatelessWidget {
  const LinkTexto({
    super.key,
    required this.texto,
    required this.destaque,
    required this.onTap,
    required this.cor,
    this.corDestaque,
  });

  final String texto, destaque;
  final VoidCallback onTap;
  final Color cor;
  final Color? corDestaque;

  @override
  Widget build(BuildContext context) {
    final d = corDestaque ?? cor;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text.rich(
          TextSpan(
            text: texto,
            style: TextStyle(color: cor, fontSize: 14),
            children: [
              TextSpan(
                text: destaque,
                style: TextStyle(
                  color: d,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaComPainel extends StatelessWidget {
  const TelaComPainel({
    super.key,
    required this.fundo,
    required this.painel,
    required this.topo,
    required this.child,
    this.flexTopo,
    this.flexPainel = 1,
  });

  final Color fundo, painel;
  final Widget topo, child;
  final int? flexTopo;
  final int flexPainel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          flexTopo == null
              ? topo
              : Expanded(flex: flexTopo!, child: Center(child: topo)),
          Expanded(
            flex: flexPainel,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: painel,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}