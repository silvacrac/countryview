import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:countryview/nucleo/modelos/pais.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/blocs/pais_bloc.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/blocs/pais_estado.dart';
import 'package:countryview/funcionalidades/paises/apresentacao/widgets/cartao_pais_detalhado.dart';

class TelaPaises extends StatefulWidget {
  const TelaPaises({Key? key}) : super(key: key);

  @override
  _TelaPaisesState createState() => _TelaPaisesState();
}

class _TelaPaisesState extends State<TelaPaises> {
  final TextEditingController _searchController = TextEditingController();
  List<Pais> _filteredCountries = [];
  Pais? _selectedCountry;
  final PageController _pageController = PageController();
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<PaisBloc>().buscarPaises();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _pageController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();

    super.dispose();
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    final allCountries =
        (context.read<PaisBloc>().state as PaisesCarregados?)?.paises ?? [];
    if (query.isEmpty) {
      setState(() {
        _filteredCountries = allCountries;
        _selectedCountry = null;
      });
      return;
    }

    setState(() {
      _filteredCountries = allCountries
          .where((country) => country.nome.toLowerCase().contains(query))
          .toList();
      if (_filteredCountries.isNotEmpty) {
        _selectedCountry = _filteredCountries.first;
      } else {
        _selectedCountry = null;
      }
      if (_selectedCountry != null) {
        final index = allCountries.indexOf(_selectedCountry!);
        if (_pageController.hasClients) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      }
    });
  }

  void _onCountrySelected(Pais country) {
    final allCountries =
        (context.read<PaisBloc>().state as PaisesCarregados?)?.paises ?? [];
    setState(() {
      _selectedCountry = country;
      if (_selectedCountry != null) {
        final index = allCountries.indexOf(_selectedCountry!);
        if (_pageController.hasClients) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      }
    });
  }

  void _showCountryDetailsPopup(Pais country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetalhePaisPopup(pais: country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900], // Cor elegante
        title: const Text('CountryView',  style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<PaisBloc, PaisEstado>(
        builder: (context, state) {
          if (state is PaisCarregando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaisesCarregados) {
            if (_filteredCountries.isEmpty) {
              _filteredCountries = state.paises;
              if (_selectedCountry == null && state.paises.isNotEmpty) {
                _selectedCountry = state.paises.first;
              }
            }

            return _buildMainContent(state.paises);
          } else if (state is PaisErro) {
            return Center(child: Text('Erro: ${state.mensagem}'));
          }
          return const Center(child: Text("Nenhum país encontrado"));
        },
      ),
    );
  }

  Widget _buildMainContent(List<Pais> countries) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: const InputDecoration(
              labelText: 'Pesquisar país...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        if (!_isSearchFocused)
          Expanded(
            flex: 2,
            child: _buildCountryList(),
          ),
        if (_selectedCountry != null)
          Expanded(
            flex: 4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: countries.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedCountry = countries[index];
                  if (_searchController.text.isNotEmpty) {
                    _onSearchChanged();
                  }
                });
              },
              itemBuilder: (context, index) {
                return _buildCountryDetails(countries[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCountryList() {
    if (_filteredCountries.isEmpty) {
      return const Center(child: Text("Nenhum país encontrado"));
    }
    return ListView.builder(
      itemCount: _filteredCountries.length,
      itemBuilder: (context, index) {
        final country = _filteredCountries[index];
        return InkWell(
          onTap: () {
            _onCountrySelected(country);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(country.nome)),
                Image.network(country.urlBandeira,
                    height: 30,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryDetails(Pais country) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(country.urlBandeira,
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error)),
          const SizedBox(height: 16),
          Text(country.nome,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DataTable(
            columnSpacing: 16,
            horizontalMargin: 16,
            columns: const [
              DataColumn(
                  label: Text('Atributo',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Valor',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(
                    Text('Capital', style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.capital)),
              ]),
              DataRow(cells: [
                const DataCell(
                    Text('Região', style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.regiao)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Sub-Região',
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.subregiao)),
              ]),
              DataRow(cells: [
                const DataCell(Text('População',
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.populacao.toString())),
              ]),
              DataRow(cells: [
                const DataCell(
                    Text('Área', style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.area.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Nome Nativo',
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.nomeNativo)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Fuso Horário',
                    style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(country.fusosHorarios.join(', '))),
              ]),
            ],
          ),
           const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showCountryDetailsPopup(country),
              child: const Text('Saber Mais'),
            ),
        ],
      ),
    );
  }
}