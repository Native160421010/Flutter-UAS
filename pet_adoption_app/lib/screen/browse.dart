import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;

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
          Container(
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
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.pets, size: 30),
                title: GestureDetector(
                    child: Text(hewan[index].nama),
                    // onTap: () {
                    //   // Navigator.push(
                    //   //   context,
                    //   //   MaterialPageRoute(
                    //   //     builder: (context) =>
                    //   //         DetailPop(movieID: PMs[index].id),
                    //   //   ),
                    //   // );
                    // }
                    ),
                subtitle: Text(PopPets[index].keterangan),
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