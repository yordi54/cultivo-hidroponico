import 'package:cultivo_hidroponico/repositories/privacy_terms_repository.dart';
import 'package:flutter/material.dart';


class PrivacyTermsScreen extends StatefulWidget {
  const PrivacyTermsScreen({super.key});

  @override
  State<PrivacyTermsScreen> createState() => _PrivacyTermsScreenState();
}

class _PrivacyTermsScreenState extends State<PrivacyTermsScreen> {

  PrivacyTermsRepository privacyTermsRepository = PrivacyTermsRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Términos y condiciones'),
        ),
        backgroundColor: Colors.green,
        elevation: 10,
      ),
      body: FutureBuilder(
          future: Future.wait([
            privacyTermsRepository.getPoliticas(),
            privacyTermsRepository.getPrivacidad(),
          ]),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Construir la lista principal
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 0 ?
                          _checkTitle("Política de privacidad") :
                          _checkTitle("Terminos y condiciones"),
                          for (var item in snapshot.data![index])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    item['description'],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
    );
  }

  _checkTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          const Divider(height: 8.0,)
        ],
      ),
    );
  }
}
