import 'package:flutter/material.dart';
import 'package:countryview/nucleo/modelos/pais.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import 'package:xml/xml.dart';
import 'package:csv/csv.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class DetalhePaisPopup extends StatefulWidget {
  final Pais pais;
  const DetalhePaisPopup({Key? key, required this.pais}) : super(key: key);

  @override
  _DetalhePaisPopupState createState() => _DetalhePaisPopupState();
}

class _DetalhePaisPopupState extends State<DetalhePaisPopup> {
  Future<void> _exportData(String format) async {
    try {
      String? data;
      List<int>? bytes;

      if (format == 'xls') {
        bytes = await _exportToExcel();
      } else if (format == 'csv') {
        data = await _exportToCsv();
      } else if (format == 'xml') {
        data = await _exportToXml();
      } else {
        return;
      }

      if ((format != 'xls' && (data == null || (data?.isEmpty ?? true))) ||
          (format == 'xls' && (bytes == null || bytes.isEmpty))) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erro ao gerar dados para exportação!')),
          );
        }
        return;
      }

      if (kIsWeb) {
        if (format == 'xls') {
          _downloadFileWeb(bytes!, format);
        } else {
          _downloadFileWeb(data!, format);
        }
      } else {
        if (format == 'xls') {
          _downloadFileMobile(bytes!, format);
        } else {
          _downloadFileMobile(data!, format);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao exportar para $format: $e")),
        );
      }
    }
  }

  void _downloadFileWeb(dynamic data, String format) {
    final String fileName = "country_data_${widget.pais.nome}.$format";
    late final html.Blob blob;
    if (data is List<int>) {
      blob = html.Blob([Uint8List.fromList(data)]);
    } else if (data is String) {
      blob = html.Blob([data]);
    }

    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
    anchor.remove();
  }

  Future<void> _downloadFileMobile(dynamic data, String format) async {
    final String fileName = "country_data_${widget.pais.nome}.$format";
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (data is String) {
      await file.writeAsString(data);
    } else if (data is List<int>) {
      await file.writeAsBytes(data);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      if (data is String) {
        Share.shareXFiles([XFile(path)],
            text:
                "Dados exportados do pais ${widget.pais.nome} para o formato $format");
      } else {
        Share.shareXFiles([XFile(path)],
            text:
                "Dados exportados do pais ${widget.pais.nome} para o formato $format");
      }
    } else {
      OpenFile.open(path);
    }
  }

  Future<List<int>?> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add Title
    sheet.appendRow([TextCellValue("CountryView")]);

    // Add Image URL Header
    sheet.appendRow([TextCellValue("URL da Bandeira")]);

    // Add Image URL
    sheet.appendRow([TextCellValue(widget.pais.urlBandeira)]);

    //Headers Table
    sheet.appendRow([
      TextCellValue('Atributo'),
      TextCellValue('Valor'),
    ]);

    sheet.appendRow([
      TextCellValue('Nome'),
      TextCellValue(widget.pais.nome),
    ]);

    sheet.appendRow([
      TextCellValue('Capital'),
      TextCellValue(widget.pais.capital),
    ]);
    sheet.appendRow([
      TextCellValue('Região'),
      TextCellValue(widget.pais.regiao),
    ]);
    sheet.appendRow([
      TextCellValue('Sub-Região'),
      TextCellValue(widget.pais.subregiao),
    ]);

    sheet.appendRow([
      TextCellValue('População'),
      TextCellValue(widget.pais.populacao.toString()),
    ]);

    sheet.appendRow([
      TextCellValue('Área'),
      TextCellValue(widget.pais.area.toString()),
    ]);
    sheet.appendRow([
      TextCellValue('Nome Nativo'),
      TextCellValue(widget.pais.nomeNativo),
    ]);
    sheet.appendRow([
      TextCellValue('Fuso Horário'),
      TextCellValue(widget.pais.fusosHorarios.join(', ')),
    ]);

    final bytes = excel.encode();
    return bytes;
  }

  Future<String?> _exportToCsv() async {
    List<List<dynamic>> data = [
      ['CountryView'],
      [''],
      ['URL da Bandeira'],
      [widget.pais.urlBandeira],
      [''],
      ['Atributo', 'Valor'],
      ['Nome', widget.pais.nome],
      ['Capital', widget.pais.capital],
      ['Região', widget.pais.regiao],
      ['Sub-Região', widget.pais.subregiao],
      ['População', widget.pais.populacao.toString()],
      ['Área', widget.pais.area.toString()],
      ['Nome Nativo', widget.pais.nomeNativo],
      ['Fuso Horário', widget.pais.fusosHorarios.join(', ')],
    ];

    // Adicione o cabeçalho correto e os dados como linhas
    List<List<String>> csvData = [
      ['Atributo', 'Valor'],
      ['Nome', widget.pais.nome],
      ['Capital', widget.pais.capital],
      ['Região', widget.pais.regiao],
      ['Sub-Região', widget.pais.subregiao],
      ['População', widget.pais.populacao.toString()],
      ['Área', widget.pais.area.toString()],
      ['Nome Nativo', widget.pais.nomeNativo],
      ['Fuso Horário', widget.pais.fusosHorarios.join(', ')],
    ];
    String csv = const ListToCsvConverter().convert(csvData, eol: '\n');
    return csv;
  }

  Future<String?> _exportToXml() async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('countryView', nest: () {
      builder.element('title', nest: () {
        builder.text('CountryView');
      });
      builder.element('bandeiraURL', nest: () {
        builder.text(widget.pais.urlBandeira);
      });
      builder.element('detalhes', nest: () {
        builder.element('nome', nest: () {
          builder.text(widget.pais.nome);
        });
        builder.element('capital', nest: () {
          builder.text(widget.pais.capital);
        });
        builder.element('regiao', nest: () {
          builder.text(widget.pais.regiao);
        });
        builder.element('subregiao', nest: () {
          builder.text(widget.pais.subregiao);
        });
        builder.element('populacao', nest: () {
          builder.text(widget.pais.populacao.toString());
        });
        builder.element('area', nest: () {
          builder.text(widget.pais.area.toString());
        });
        builder.element('nomeNativo', nest: () {
          builder.text(widget.pais.nomeNativo);
        });
        builder.element('fusosHorarios', nest: () {
          builder.text(widget.pais.fusosHorarios.join(', '));
        });
      });
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(widget.pais.urlBandeira,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error)),
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
                      const DataCell(Text('Nome',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.nome)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Capital',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.capital)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Região',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.regiao)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Sub-Região',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.subregiao)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('População',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.populacao.toString())),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Área',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.area.toString())),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Nome Nativo',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.nomeNativo)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Fuso Horário',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(widget.pais.fusosHorarios.join(', '))),
                    ]),
                  ]),
              const SizedBox(height: 20),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _exportData('xls'),
                      child: const Text('Exportar para XLS'),
                    ),
                    ElevatedButton(
                      onPressed: () => _exportData('csv'),
                      child: const Text('Exportar para CSV'),
                    ),
                    ElevatedButton(
                      onPressed: () => _exportData('xml'),
                      child: const Text('Exportar para XML'),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
