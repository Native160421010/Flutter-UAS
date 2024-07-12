// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/class/proposal.dart';
import 'package:pet_adoption_app/screen/EditOffer.dart';
import 'package:pet_adoption_app/screen/OfferHistory.dart';
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptOffer extends StatefulWidget {
  final int pet_id;

  AcceptOffer({Key? key, required this.pet_id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AcceptOfferPageState();
  }
}

class _AcceptOfferPageState extends State<AcceptOffer> {
  List<Proposal> proposalList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<void> bacaData() async {
    proposalList.clear();
    try {
      final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/ProposalList.php"),
        body: {'pet_id': widget.pet_id.toString()},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json['result'] == "success") {
          List<dynamic> data = json['data'];
          setState(() {
            proposalList = data.map((prop) => Proposal.fromJson(prop)).toList();
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load proposals');
        }
      } else {
        throw Exception('Failed to load proposals');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, e.g., show a dialog or message to the user
    }
  }

  void decide(String username, int pet_id, int decision) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/Decision.php"),
        body: {
          'username': username,
          'pet_id': pet_id.toString(),
          'status': decision.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deciding Successful!')));
        });
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('See Proposals'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  ListView.builder(
                    itemCount: proposalList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                                        'https://ubaya.me/flutter/160421010/Pet/Gambar/${proposalList[index].pet_id}.jpg',
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Proposer: ${proposalList[index].username}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Plead: ${proposalList[index].description}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          decide(
                                            proposalList[index].username,
                                            widget.pet_id,
                                            1,
                                          );
                                        },
                                        child: const Text('Accept'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          decide(
                                            proposalList[index].username,
                                            widget.pet_id,
                                            2,
                                          );
                                        },
                                        child: const Text('Reject'),
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
                  if (proposalList.isEmpty)
                    const Center(
                      child: Text(
                        'No proposals... Yet!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ));
  }
}
