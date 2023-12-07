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
          child: Text('Políticas y Privacidad'),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var item in snapshot.data![index])
                            Column(
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
                                    fontSize: 14.0,
                                  ),
                                ),
                                const Divider(),
                              ],
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

  _infoColumn(List content) {
    return Column(
      children: [
        const Text("Privacidad y Política"),
        ListView.builder(
          shrinkWrap: true, 
          itemCount: content[0]["privacy_policy"].lenght,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(content[index]["title"],
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                  ),
                ),
                Text(content[index]["description"],
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            );
          }
        ),
      ],
    );
  }
}
