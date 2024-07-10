import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/class/pet.dart';

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

  Future<void> bacaData() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
        body: {'id': widget.petID.toString()},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        setState(() {
          _pm = Pets.fromJson(
              json['data'][0]);
        });
      } else {
        throw Exception('Failed to read API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

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
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            _pm!.nama,
            style: const TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              _pm!.jenis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
