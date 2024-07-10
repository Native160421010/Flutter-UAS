import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;

class Propose extends StatefulWidget {
  int petID;
  Propose({super.key, required this.petID});
  @override
  State<StatefulWidget> createState() {
    return _ProposeState();
  }
}

Pets? _pm;

class _ProposeState extends State<Propose> {
  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
      body: {'id': widget.petID.toString()},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pm = Pets.fromJson(json['data']);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propose'),
      ),
      body: ListView(children: <Widget>[
        tampilData(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdoptPage(petID: widget.petID)),
              );
            },
            child: const Text('Adopt'),
          ),
        ),
      ]),
    );
  }
}

Widget tampilData() {
  if (_pm == null) {
    return const CircularProgressIndicator();
  }
  return Card(
    elevation: 10,
    margin: const EdgeInsets.all(10),
    child: Column(children: <Widget>[
      Text(_pm!.nama, style: const TextStyle(fontSize: 25)),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(_pm!.jenis, style: const TextStyle(fontSize: 15)),
      ),
      const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(_pm!.description, style: const TextStyle(fontSize: 15)),
      ),
      const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Pemilik :", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(_pm!.username_reviewe, style: const TextStyle(fontSize: 15)),
      ),
      const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Status :", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(_pm!.keterangan, style: const TextStyle(fontSize: 15)),
      ),
    ]),
  );
}

class AdoptPage extends StatelessWidget {
  final int petID;

  AdoptPage({super.key, required this.petID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopt Pet'),
      ),
      body: Center(
        child: Text('Adopting pet with ID: $petID'),
      ),
    );
  }
}
