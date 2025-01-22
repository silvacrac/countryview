import 'package:flutter/material.dart';
import 'package:countryview/nucleo/modelos/pais.dart';

class CartaoPais extends StatelessWidget {
  final Pais pais;

  const CartaoPais({Key? key, required this.pais}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pais.nome, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text("Capital: ${pais.capital}"),
            const SizedBox(height: 4),
            Text("Região: ${pais.regiao}"),
            const SizedBox(height: 4),
            Text("Sub-região: ${pais.subregiao}"),
            const SizedBox(height: 4),
            Text("População: ${pais.populacao}"),
            const SizedBox(height: 4),
            Text("Área: ${pais.area}"),
            const SizedBox(height: 4),
            Text("Nome Nativo: ${pais.nomeNativo}"),
            const SizedBox(height: 4),
            Text(
                "Fuso Horário: ${pais.fusosHorarios.join(', ')}"), // Display Timezones
            const SizedBox(height: 4),
            Image.network(
              pais.urlBandeira,
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}
