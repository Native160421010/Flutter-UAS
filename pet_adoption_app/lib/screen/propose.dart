import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/class/pet.dart';
import 'package:pet_adoption_app/screen/adopt.dart';
import 'package:pet_adoption_app/screen/login.dart';

class Propose extends StatefulWidget {
  final int petID;

  Propose({Key? key, required this.petID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProposeState();
}

class _ProposeState extends State<Propose> {
  Pets? _pm;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
        body: {'id': widget.petID.toString()});
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

  // Future<void> bacaData() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           "https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
  //       body: {'id': widget.petID.toString()},
  //     );
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> json = jsonDecode(response.body);
  //       setState(() {
  //         _pm = Pets.fromJson(json['data'][0]);
  //       });
  //     } else {
  //       throw Exception('Failed to read API');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail of Popular Movie'),
      ),
      body: _pm == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                tampilData(),
              ],
            ),
    );
  }

  Widget tampilData() {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 300.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://ubaya.me/flutter/160421010/Pet/Gambar/${_pm!.id}.jpg')),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            Text(_pm!.nama,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${_pm!.jenis} . ${_pm!.lokasi}',
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
            Text(
              'Status: ${_pm!.keterangan}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: _pm!.keterangan == 'Available'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const Divider(
              height: 15,
            ),
            Text('${_pm!.age} . ${_pm!.gender}',
                style: const TextStyle(fontSize: 10)),
            const Divider(
              height: 15,
            ),
            const Padding(
                padding: EdgeInsets.all(0),
                child: Text("Charateristics",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _pm?.karakter
                          ?.map((item) => item['karakter_name'])
                          .join(', ') ??
                      '',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 10),
                ),
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(0),
                child: Text("Health",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _pm?.health?.map((item) => item['health_name']).join(', ') ??
                      '',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 10),
                ),
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(0),
                child: Text("Coat Length",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Text(_pm!.coat_length,
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
            const Padding(
                padding: EdgeInsets.all(0),
                child: Text("Description",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Text(_pm!.description,
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
            const Padding(
                padding: EdgeInsets.all(0),
                child: Text("Previous Owner",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Text(_pm!.username_reviewee,
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  // EDIT SINI MIKE ======================================================================
                  MaterialPageRoute(builder: (context) => Adopt()),
                );
              },
              child: const Text('Adopt'),
            ),
          ])
        ],
      ),
    );
  }
}
