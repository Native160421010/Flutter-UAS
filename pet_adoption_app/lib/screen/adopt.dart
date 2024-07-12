import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adoption_app/class/pet.dart';
import 'package:pet_adoption_app/main.dart';
import 'package:pet_adoption_app/screen/propose.dart';
import 'package:pet_adoption_app/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Adopt extends StatefulWidget {
  final int petID;

  Adopt({Key? key, required this.petID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdoptState();
}

class _AdoptState extends State<Adopt> {
  Pets? _pm;
  String username = '';
  String description = '';
  String errorAdopt = '';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php',
        ),
        body: {'id': widget.petID.toString()},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        setState(() {
          _pm = Pets.fromJson(json['data']);
        });
      } else {
        throw Exception('Failed to read API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void sendMessage(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://ubaya.me/flutter/160421010/UAS/Propose/sendpropose.php',
        ),
        body: {
          'username': username,
          'pet_id': widget.petID.toString(),
          'description': description,
        },
      );
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sukses Mengirim Data'),
              duration: Duration(milliseconds: 300),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error')),
        );
        throw Exception('Failed to read API');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Pet'),
      ),
      body: _pm == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    Text("You're adopting ${_pm!.nama}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Plea',
                          hintText: 'Enter your adoption plea!',
                        ),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ),
                    ),
                    if (errorAdopt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          errorAdopt,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 25,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            sendMessage(widget.petID);
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => MainScreen(),
                            //   ),
                            //   (route) => false,
                            // );
                          },
                          child: const Text(
                            'Adopt',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
