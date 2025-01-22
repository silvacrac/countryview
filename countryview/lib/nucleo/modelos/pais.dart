class Pais {
  final String nome;
  final String capital;
  final String regiao;
  final String subregiao;
  final int populacao;
  final double area;
  final List<String> fusosHorarios;
  final String nomeNativo;
  final String urlBandeira;

  Pais({
    required this.nome,
    required this.capital,
    required this.regiao,
    required this.subregiao,
    required this.populacao,
    required this.area,
    required this.fusosHorarios,
    required this.nomeNativo,
    required this.urlBandeira,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    final nome = json["name"]?["common"] as String? ?? 'N/A';
    final capital = (json["capital"] as List<dynamic>?)?.isNotEmpty == true
        ? json["capital"][0] as String? ?? 'N/A'
        : 'N/A';
    final regiao = json["region"] as String? ?? 'N/A';
    final subregiao = json["subregion"] as String? ?? 'N/A';
    final populacao = (json["population"] as num?)?.toInt() ?? 0;
    final area = (json["area"] as num?)?.toDouble() ?? 0.0;
    final timezones =
        (json["timezones"] as List<dynamic>?)?.cast<String>() ?? [];

    String nativeName = 'N/A';
    if (json["name"] != null && json["name"]["nativeName"] != null) {
      final nativeNameMap = json["name"]["nativeName"] as Map<String, dynamic>?;
      if (nativeNameMap != null && nativeNameMap.isNotEmpty) {
        final firstKey = nativeNameMap.keys.first;
        final nativeNameData = nativeNameMap[firstKey] as Map<String, dynamic>?;
        if (nativeNameData != null) {
          nativeName = nativeNameData["common"] as String? ?? 'N/A';
        }
      }
    }

    final urlBandeira = json["flags"]?["png"] as String? ?? '';

    return Pais(
      nome: nome,
      capital: capital,
      regiao: regiao,
      subregiao: subregiao,
      populacao: populacao,
      area: area,
      fusosHorarios: timezones,
      nomeNativo: nativeName,
      urlBandeira: urlBandeira,
    );
  }
}
