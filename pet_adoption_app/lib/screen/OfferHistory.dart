// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/screen/AcceptOffer.dart';
import 'package:pet_adoption_app/screen/EditOffer.dart';
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Pets> hewan = [];

String _temp = 'waiting API respond…';

class OfferHistory extends StatefulWidget {
  static var bacaData;

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
        title: const Text('Offer History'),
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
                      Column(
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
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color:
                                        hewan[index].keterangan == 'Available'
                                            ? Colors.grey
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hewan[index].keterangan == 'Available')
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditOffer(petID: hewan[index].id),
                                        ),
                                      );
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AcceptOffer(
                                              pet_id: hewan[index].id),
                                        ),
                                      );
                                    },
                                    child: const Text('See Proposals'),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
