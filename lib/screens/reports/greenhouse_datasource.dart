import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GreenHouseDataSource extends DataGridSource {

  final List<GridColumn> _columns = [ //Definir las columnas
    GridColumn(
      columnName: 'description',
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: const Text(
          'Descripción',
          overflow: TextOverflow.ellipsis,
        )
      ),
    ),
    GridColumn(
      columnName: 'greenhouse',
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: const Text(
          'Invernadero',
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ),
    ),
    GridColumn(
      columnName: 'date',
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: const Text(
          'Fecha',
          overflow: TextOverflow.ellipsis,
        )
      ),
    ),
    GridColumn(
      columnName: 'hour',
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: const Text(
          'Hora',
          overflow: TextOverflow.ellipsis,
        )
      ),
    ),
  ];

  List<GridColumn> get columns => _columns; 
  List<DataGridRow> dataGridRows = [];

  GreenHouseDataSource({required List<GreenHouseReport> greenhouses}){
    dataGridRows = greenhouses
    .map<DataGridRow>(
      (dataGridRow) => DataGridRow(
      cells: [
          DataGridCell<String>(
            columnName: 'description',
            value: dataGridRow.description
          ),
          DataGridCell<String>(
            columnName: 'greenhouse',
            value: dataGridRow.greenhouse
          ),
          DataGridCell<String>(
            columnName: 'date',
            value: dataGridRow.date
          ),
          DataGridCell<String>(
            columnName: 'hour',
            value: dataGridRow.hour
          ),
        ]
      )
    ).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 2));
    _addMoreRows(15);
    notifyListeners();
  }
  
  void _addMoreRows(int i) {}
}