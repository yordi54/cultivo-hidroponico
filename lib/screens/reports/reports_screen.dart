import 'dart:core';

import 'package:cultivo_hidroponico/controllers/report_controller.dart';
import 'package:cultivo_hidroponico/screens/reports/show_item_datagrid.dart';
import 'package:cultivo_hidroponico/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

import 'package:cultivo_hidroponico/helper/save_file_mobile.dart';
import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:cultivo_hidroponico/screens/reports/dealer_datagridsource.dart';
import 'package:cultivo_hidroponico/screens/reports/greenhouse_datasource.dart';

/// Render data grid with editing.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  // Crea un DataTable con las columnas especificadas
  late GreenHouseDataSource _greenhouseDataSource; //Definir datos datasource a partir de dealerDataGrid
  
  final DataGridController _controller = DataGridController(); //Controller datagrid
  final ReportController _reportController = Get.put(ReportController());
  late Future<List<GreenHouseReport>> _dataSource;

  final TextEditingController _itemSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataSource = _reportController.fetchFirstList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildExportingButtons(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Eventos ocurridos: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    MaterialButton(
                      color: Colors.green,
                      child: const Text(
                        "Ver ítem",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        if(_controller.selectedRows.isNotEmpty){
                          List<DataGridCell> selectedRow = _controller.selectedRow!.getCells();
                          GreenHouseReport greenHouseReport = GreenHouseReport.fromJson({
                            "description": selectedRow[0].value,
                            "greenhouse": selectedRow[1].value,
                            "date": selectedRow[2].value,
                            "hour": selectedRow[3].value
                          });
                          Get.to(() => ShowItemDataGrid(greenHouseReport: greenHouseReport,)); 
                        }else{
                          Constants.snackbar(context, "Seleccione un ítem");
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemSearch,
                        decoration: const InputDecoration(labelText: 'Ej: Invernadero 1'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dataSource = _reportController.searchDocumentsByGreenHouse(_itemSearch.text);
                        });
                      },
                      child: const Text('Buscar'),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<GreenHouseReport>>(
                future: _dataSource,
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  } else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final greenHouseReports = snapshot.data;
                    if (greenHouseReports == null || greenHouseReports.isEmpty) {
                      return const Text('No hay datos disponibles.');
                    }
                    _greenhouseDataSource = GreenHouseDataSource(greenhouses: greenHouseReports);
              
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2.0,
                      child: Center(
                        child: SfDataGrid(
                          key: key,
                          columns: _greenhouseDataSource.columns,
                          source: _greenhouseDataSource,
                          controller: _controller,
                          selectionMode: SelectionMode.singleDeselect,
                        ),
                      ),
                    );
                  }
                }
              ),
              TextButton(onPressed: () async {
                  setState(() {
                    _dataSource = _reportController.fetchNextReport();
                  });
                }, 
                child: const Center(
                  child: Text("Ver más"),
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportingButtons() {
    Future<void> exportDataGridToExcel() async {
      final Workbook workbook = key.currentState!.exportToExcelWorkbook(
          cellExport: (DataGridCellExcelExportDetails details) {
        if (details.cellType == DataGridExportCellType.columnHeader) {
          details.excelRange.cellStyle.hAlign = HAlignType.right;
        }
      });
      final List<int> bytes = await workbook.save();
      FileSaveHelper.saveAndLaunchFile(bytes, "reporte.xlsx");
      workbook.dispose();
    }

    Future<void> exportDataGridToPdf() async {
      final ByteData data = await rootBundle.load('images/logo_romero.png');
      final PdfDocument document = key.currentState!.exportToPdfDocument(
      fitAllColumnsInOnePage: true,
      cellExport: (DataGridCellPdfExportDetails details) {
        if (details.cellType == DataGridExportCellType.row) {
          if (details.columnName == 'Shipped Date') {
            details.pdfCell.value = DateFormat('MM/dd/yyyy')
                .format(DateTime.parse(details.pdfCell.value));
          }
        }
      },
      headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
        final double width = details.pdfPage.getClientSize().width;
        final PdfPageTemplateElement header =
            PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

        header.graphics.drawImage(
            PdfBitmap(data.buffer
                .asUint8List(data.offsetInBytes, data.lengthInBytes)),
            Rect.fromLTWH(width - 100, 0, 50, 50));

        header.graphics.drawString(
          'Reporte',
          PdfStandardFont(PdfFontFamily.helvetica, 13,
              style: PdfFontStyle.bold),
          bounds: const Rect.fromLTWH(0, 25, 200, 60),
        );

        details.pdfDocumentTemplate.top = header;
      });
      //Save the document
      List<int> bytes = await document.save();
      FileSaveHelper.saveAndLaunchFile(bytes, "reporte.pdf");
      document.dispose();
    }

    return Row(
      children: <Widget>[
        _buildExportingButton('Excel', 'images/ExcelExport.png', Colors.amber,
            onPressed: exportDataGridToExcel),
        _buildExportingButton('PDF', 'images/PdfExport.png', Colors.deepOrange,
            onPressed: exportDataGridToPdf)
      ],
    );
  }

  Widget _buildExportingButton(String buttonName, String imagePath, Color color,
      {required VoidCallback onPressed}) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        child: SizedBox(
          width: 150.0,
          height: 40.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ImageIcon(
                  AssetImage(imagePath),
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Text(buttonName, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}