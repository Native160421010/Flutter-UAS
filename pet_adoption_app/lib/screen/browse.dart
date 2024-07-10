// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/screen/Adoption.dart';

List<Pets> hewan = [];
String _txtcari = " ";

String _temp = 'waiting API respond…';

Future<String> fetchData() async {
  final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421010/Pet/petslist.php"),
      body: {'cari': _txtcari});
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to read API');
  }
}

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BrowsePageState();
  }
}

class _BrowsePageState extends State<BrowsePage> {
  bacaData() {
    hewan.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var pet in json['data']) {
        Pets pm = Pets.fromJson(pet);
        hewan.add(pm);
      }
      setState(() {
        _txtcari = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Browse'),
        ),
        body: ListView(children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Search Pet:',
            ),
            onFieldSubmitted: (value) {
              _txtcari = value;
              bacaData();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            // -400
            child: DaftarHewan(hewan),
          ),
        ]));
  }
}

Widget DaftarHewan(PopPets) {
  if (PopPets != null) {
    return ListView.builder(
        itemCount: PopPets.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              margin: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: const Icon(Icons.pets, size: 30),
                    title: GestureDetector(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 300.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://ubaya.me/flutter/160421010/Pet/Gambar/${PopPets[index].id}.jpg')),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                            ),
                          ),
                          Text(hewan[index].nama,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(hewan[index].jenis,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 10)),
                          const Divider(
                            height: 15,
                          ),
                          Text(hewan[index].description,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 10)),
                          Text('Status: ${PopPets[index].keterangan}',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 10))
                        ]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Adoption(
                                      hewan[index].id,
                                    )),
                          );
                        }),
                  ),
                  // Row(
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //       builder: (context) => EditPopMovie(
                  //         //             PMs[index].id,
                  //         //           )),
                  //         // );
                  //       },
                  //       child: const Text('Edit'),
                  //     ),
                  //     // ElevatedButton(
                  //     //   onPressed: () {
                  //     //     delete(PMs[index].id);
                  //     //   },
                  //     //   child: const Text('Delete'),
                  //     // ),
                  //   ],
                  // )
                ],
              ));
        });
  } else {
    return const CircularProgressIndicator();
  }
}
