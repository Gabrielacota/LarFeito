abstract class FamilyRepository {
  // síncrono
  // não garante unicidade
  String gerarCodigo();

  // assíncronos
  Future<void> criarFamilia(String codigo);
  Future<void> entrarNaFamilia(String codigo);
}

class FamilyException implements Exception {
  final String message;
  const FamilyException(this.message);

  @override
  String toString() => message;
}