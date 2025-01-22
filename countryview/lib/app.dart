import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:countryview/nucleo/servicos/servico_api.dart';
import 'package:countryview/funcionalidades/paises/dados/fontes_dados/fonte_dados.dart';
import 'package:countryview/funcionalidades/paises/dados/repositorios/repositorio_pais.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/blocs/pais_bloc.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/paginas/tela_paises.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final servicoApi = ServicoApi();
    final fonteDadosRemota = FonteDadosRemota(servicoApi);
    final repositorioPais = RepositorioPais(fonteDadosRemota);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PaisBloc(repositorioPais)),
      ],
      child: MaterialApp(
          title: 'App Países',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const TelaPaises(),
      ),
    );
  }
}