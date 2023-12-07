import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacyTermsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPoliticas() async {
    QuerySnapshot querySnapshot = await _firestore.collection('privacy_policy').get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    List docsResult = [];

    for(var doc in docs){
      docsResult.add({
        "name": doc["name"],
        "description": doc["description"],
      });
    }
    return docsResult;
  }

  Future<List> getPrivacidad() async {
    QuerySnapshot querySnapshot = await _firestore.collection('terms_and_conditions').get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    List docsResult = [];

    for(var doc in docs){
      docsResult.add({
        "name": doc["name"],
        "description": doc["description"],
      });
    }
    return docsResult;
  }
}