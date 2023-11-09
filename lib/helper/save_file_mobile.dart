import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    
    //Get external storage directory
      final directory = await getApplicationSupportDirectory();
      //Get directory path
      final path = directory.path;
      //Create an empty file to write PDF data
      File file = File('$path/$fileName');
      //Write PDF data
      await file.writeAsBytes(bytes, flush: true);
      //Open the PDF document in mobile
      OpenFile.open('$path/$fileName');
  }
}