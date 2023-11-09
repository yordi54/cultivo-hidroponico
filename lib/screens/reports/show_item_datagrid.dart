
import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:flutter/material.dart';

class ShowItemDataGrid extends StatefulWidget {

  GreenHouseReport greenHouseReport;
  ShowItemDataGrid({ super.key, required this.greenHouseReport });

  @override
  State<ShowItemDataGrid> createState() => _ShowItemDataGridState();
}

class _ShowItemDataGridState extends State<ShowItemDataGrid> {
  @override
  Widget build(BuildContext context) {

    GreenHouseReport itemReport = widget.greenHouseReport;
    print(itemReport);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte'),
        backgroundColor: Colors.green, // Color de la barra de navegación
      ),
      body: Center(
        child: Card(
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    "Evento seleccionado: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Text(
                  'Descripción:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green, // Color del texto
                  ),
                ),
                Text(
                  itemReport.description,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Invernadero:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                Text(
                  itemReport.greenhouse,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fecha:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                Text(
                  itemReport.date,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hora:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                Text(
                  itemReport.hour,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}