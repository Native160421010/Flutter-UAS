import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/main.dart';

class Adopt extends StatelessWidget {
  const Adopt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption - Adopt',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AdoptForm(),
    );
  }
}

class AdoptForm extends StatefulWidget {
  const AdoptForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdoptFormState();
  }
}

class _AdoptFormState extends State<AdoptForm> {
  String description = "";
  String errorAdopt = "";
  int PetId = 1;

  void sendMessage(int id) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/sendpropose.php"),
        body: {'id': id.toString()});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      Text msg = Text("Gagal mengirim data");
      if (json['result'] == 'success') {
        msg = Text("Sukses Mengirim Data!");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sukses Mengirim Data"),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Adopt a Pet'),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  hintText: 'Enter your adoption description',
                ),
                onChanged: (v) {
                  description = v;
                },
              ),
            ),
            if (errorAdopt.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  errorAdopt,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      sendMessage(PetId);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                    child: const Text(
                      'Adopt',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }
}
