import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:countryview/funcionalidades/paises/dados/repositorios/repositorio_pais.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/blocs/pais_estado.dart';

class PaisBloc extends Cubit<PaisEstado> {
  final RepositorioPais _repositorioPais;

  PaisBloc(this._repositorioPais) : super(PaisInicial()) {
    print("PaisBloc: inicializado");
  }

  Future<void> buscarPaises() async {
    print("PaisBloc: buscarPaises chamado");
    emit(PaisCarregando());
    try {
      final paises = await _repositorioPais.buscarPaises();
      print(
          "PaisBloc: buscarPaises sucesso - Quantidade de países: ${paises.length}");
      emit(PaisesCarregados(paises: paises));
    } catch (e) {
      print("PaisBloc: buscarPaises erro - $e");
      emit(PaisErro(mensagem: e.toString()));
    }
  }
}
