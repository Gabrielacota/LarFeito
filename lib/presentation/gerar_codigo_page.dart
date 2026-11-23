import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/family_repository.dart';

class GerarCodigoPage extends StatefulWidget {
  final AuthRepository authRepository;
  final FamilyRepository familyRepository;

  const GerarCodigoPage({super.key, required this.authRepository, required this.familyRepository});

  @override
  State<GerarCodigoPage> createState() => _GerarCodigoPageState();
}

class _GerarCodigoPageState extends State<GerarCodigoPage> {
  String? _codigoGerado;
  bool _salvando = false;

  void _gerarNovoCodigo() {
    setState(() {
      _codigoGerado = widget.familyRepository.gerarCodigo();
    });
  }

  // Cria a família no Firestore (families/{codigo}) e só depois devolve o código.
  Future<void> _salvarCodigo() async {
    final codigo = _codigoGerado;
    if (codigo == null) return;

    setState(() => _salvando = true);
    try {
      await widget.familyRepository.criarFamilia(codigo);
      if (!mounted) return;
      Navigator.pop(context, codigo);
    } on FamilyException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar a família: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D7FFF),
      body: Column(
        children: [
          // Logo superior
          Expanded(
            flex: 2,
            child: Center(
              child: Image.asset(
                'assets/images/logoBranca.png',
                width: 230,
              ),
            ),
          ),

          // Container branco inferior
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gerar Código',
                      style: TextStyle(
                        color: Color(0xFF5D7FFF),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Código da Família',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Botão Cinza para gerar o código
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C9095),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _salvando ? null : _gerarNovoCodigo,
                        child: Text(
                          _codigoGerado ?? 'Gerar código',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: _codigoGerado != null ? 2.0 : 0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botões Salvar e Tentar de Novo
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: (_codigoGerado == null || _salvando)
                                  ? null
                                  : _salvarCodigo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA7FF9E),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: _salvando
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF5D7FFF),
                                ),
                              )
                                  : const Text(
                                'Salvar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _salvando ? null : _gerarNovoCodigo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFBDBD),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Tentar denovo',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}