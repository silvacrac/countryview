import 'package:countryview/nucleo/modelos/pais.dart';

abstract class PaisEstado {}

class PaisInicial extends PaisEstado {}

class PaisCarregando extends PaisEstado {}

class PaisesCarregados extends PaisEstado {
  final List<Pais> paises;

  PaisesCarregados({required this.paises});
}

class PaisErro extends PaisEstado {
  final String? mensagem;

  PaisErro({this.mensagem});
}
