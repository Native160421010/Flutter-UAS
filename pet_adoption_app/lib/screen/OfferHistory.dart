// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Pets> hewan = [];

String _temp = 'waiting API respond…';

Future<String> fetchData() async {
  String? username = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString('username'));

  final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421010/Pet/YourPetsList.php"),
      body: {'username_reviewee': username});
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to read API');
  }
}

class OfferHistory extends StatefulWidget {
  const OfferHistory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OfferHistoryPageState();
  }
}

class _OfferHistoryPageState extends State<OfferHistory> {
  List<Pets> hewan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<void> bacaData() async {
    hewan.clear();
    try {
      String? username = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('username'));

      final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/Pet/YourPetsList.php"),
        body: {'username_reviewee': username},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json['result'] == "success") {
          List<dynamic> data = json['data'];
          setState(() {
            hewan = data.map((pet) => Pets.fromJson(pet)).toList();
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load pets');
        }
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, e.g., show a dialog or message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hewan.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Propose(petID: hewan[index].id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://ubaya.me/flutter/160421010/Pet/Gambar/${hewan[index].id}.jpg'),
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hewan[index].nama,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    hewan[index].jenis,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    hewan[index].description,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Status: ${hewan[index].keterangan}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
