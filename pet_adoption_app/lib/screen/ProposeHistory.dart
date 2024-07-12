// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/class/proposal.dart';
import 'package:pet_adoption_app/screen/EditOffer.dart';
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Proposal> proposal = [];

String _temp = 'waiting API respond…';

// Future<String> fetchData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? username = prefs.getString('username');

//   final response = await http.post(
//     Uri.parse(
//         "https://ubaya.me/flutter/160421010/UAS/Propose/ProposeHistory.php"),
//         // "https://ubaya.me/flutter/160421010/Pet/YourPetsList.php"),
//     body: {'username': 2},
//   );

//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to read API');
//   }
// }

class ProposeHistory extends StatefulWidget {
  const ProposeHistory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProposeHistoryPageState();
  }
}

class _ProposeHistoryPageState extends State<ProposeHistory> {
  List<Proposal> proposal = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<void> bacaData() async {
    proposal.clear();
    try {
      String? username = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('username'));

      final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/ProposeHistory.php"),
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json['result'] == "success") {
          List<dynamic> data = json['data'];
          setState(() {
            proposal = data.map((prop) => Proposal.fromJson(prop)).toList();
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load proposal');
        }
      } else {
        throw Exception('Failed to load proposal');
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
              itemCount: proposal.length,
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
                                    'https://ubaya.me/flutter/160421010/Pet/Gambar/${proposal[index].pet_id}.jpg'),
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
                                  proposal[index].username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  proposal[index].description,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const SizedBox(height: 8),
                                Text(
                                  'Status Proposal: ${proposal[index].status}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: proposal[index].status == 'Pending'
                                        ? Colors.grey
                                        : proposal[index].status == 'Accepted'
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
