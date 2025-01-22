import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicoApi {
  final String _baseUrl = 'https://restcountries.com/v3.1';

  ServicoApi() {
    print("ServicoApi: inicializado");
  }

  Future<List<dynamic>> buscarPaises() async {
    print("ServicoApi: buscarPaises chamado");
    final response = await http.get(Uri.parse(
        '$_baseUrl/all?fields=name,capital,region,subregion,population,area,timezones,flags,nativeName'));

    print("ServicoApi: buscarPaises - Status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
          "ServicoApi: buscarPaises sucesso - Quantidade de dados: ${data.length}");
      return data;
    } else {
      print("ServicoApi: buscarPaises erro");
      throw Exception('Falha ao carregar países');
    }
  }
}
