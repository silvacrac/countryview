import 'package:countryview/nucleo/servicos/servico_api.dart';

class FonteDadosRemota {
  final ServicoApi _servicoApi;

  FonteDadosRemota(this._servicoApi) {
    print("FonteDadosRemota: inicializado");
  }

  Future<List<dynamic>> buscarPaises() async {
    print("FonteDadosRemota: buscarPaises chamado");
    final dados = await _servicoApi.buscarPaises();
    print(
        "FonteDadosRemota: buscarPaises sucesso - Quantidade de dados retornados da API: ${dados.length}");
    return dados;
  }
}
