import 'dart:convert';

import 'package:cultivo_hidroponico/models/plantid_analized.dart';
import 'package:http/http.dart' as http;

class PlantIdController {
  final _baseUrl = 'https://plant.id/api/v3';
  final _token = 'CELOraxL3mIpCLV1FIS4Px5ujh8jghvgxGR9coZXdJJV9VdVrn';
  
  PlantIdController();

  Future<PlantIdAnalized?> healthAssessment(String image64) async {
    final url = Uri.parse('$_baseUrl/health_assessment');
    try {
      var res = await http.post(
        url,
        headers: {'Api-Key': _token}, 
        body: jsonEncode({'images': image64})
      );
      
      PlantIdAnalized? data;
      if(res.statusCode == 201){
        print("result ok");
        data = plantIdAnalizedFromJson(res.body);
      }
      return data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}