import 'package:countryview/nucleo/modelos/pais.dart';
import 'package:countryview/funcionalidades/paises/dados/fontes_dados/fonte_dados.dart';

class RepositorioPais {
  final FonteDadosRemota _fonteDadosRemota;

  RepositorioPais(this._fonteDadosRemota) {
    print("RepositorioPais: inicializado");
  }

  Future<List<Pais>> buscarPaises() async {
    print("RepositorioPais: buscarPaises chamado");
    final paisesJson = await _fonteDadosRemota.buscarPaises();
    print(
        "RepositorioPais: buscarPaises sucesso - Quantidade de países retornados da API: ${paisesJson.length}");
    return paisesJson.map((pais) => Pais.fromJson(pais)).toList();
  }
}
