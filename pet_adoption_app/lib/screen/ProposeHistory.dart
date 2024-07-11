import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Pets> listPropose = [];

String _temp = 'waiting API respond…';

Future<String> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username') ?? '';

  final response = await http.post(
    Uri.parse("https://ubaya.me/flutter/160421010/UAS/Propose/proposehistory.php"),
    body: {'nama': username},
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to read API');
  }
}

class Proposehistory extends StatefulWidget {
  const Proposehistory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProposalHistoryState();
  }
}

class _ProposalHistoryState extends State<Proposehistory> {
  bacaData() {
    listPropose.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var pet in json['data']) {
        Pets pm = Pets.fromJson(pet);
        listPropose.add(pm);
      }
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
        title: const Text('Propose History'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            // -400
            child: DaftarPropose(listPropose),
          ),
        ],
      ),
    );
  }
}

Widget DaftarPropose(PopPets) {
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
                          Text(listPropose[index].nama,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(listPropose[index].jenis,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 10)),
                          const Divider(
                            height: 15,
                          ),
                          Text(listPropose[index].description,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 10)),
                          Text(
                            'Status: ${PopPets[index].keterangan}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: PopPets[index].keterangan == 'Available'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Propose(
                                      petID: listPropose[index].id,
                                    )),
                          );
                        }),
                  ),
                ],
              ));
        });
  } else {
    return const CircularProgressIndicator();
  }
}
