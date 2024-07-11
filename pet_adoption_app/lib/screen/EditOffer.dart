// ignore_for_file: unnecessary_new

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pet_adoption_app/class/karakter.dart';
import 'package:pet_adoption_app/class/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOffer extends StatefulWidget {
  final int petID;
  EditOffer({Key? key, required this.petID}) : super(key: key);
  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();

  Widget comboKarakter = const Text('tambah karakter');

  int _id = 0;
  String _nama = "";
  String _jenis = "";
  int _keterangan = 0;
  String _description = "";
  String _lokasi = "";
  int _age = 0;
  int _gender = 0;
  int _coat_length = 0;
  final _controllerNama = TextEditingController();
  final _controllerJenis = TextEditingController();
  final _controllerLokasi = TextEditingController();
  final _controllerDesc = TextEditingController();

  Pets? _pm;

  Future<String> fetchData(int petID) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
        body: {'id': petID.toString()});
    if (response.statusCode == 200) {
      log('API response: ${response.body}');
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void bacaData() {
    fetchData(widget.petID).then((value) {
      Map<String, dynamic> json = jsonDecode(value);
      if (json['result'] == "success" && json['data'] != null) {
        setState(() {
          _pm = Pets.fromJson(json['data']);
          _id = _pm!.id;
          _nama = _pm!.nama;
          _jenis = _pm!.jenis;
          _lokasi = _pm!.lokasi;
          _age = _pm!.age == 'Young'
              ? 0
              : _pm!.age == 'Middle-Aged'
                  ? 1
                  : 2;
          _gender = _pm!.gender == 'Male' ? 0 : 1;
          _coat_length = _pm!.coat_length == 'Short'
              ? 0
              : _pm!.coat_length == 'Long'
                  ? 1
                  : 2;
          _keterangan = _pm!.keterangan == 'Available' ? 0 : 1;
          _description = _pm!.description;

          _controllerNama.text = _nama;
          _controllerJenis.text = _jenis;
          _controllerLokasi.text = _lokasi;
          _controllerDesc.text = _description;
        });
      } else {
        log('Failed to fetch data or no data found.');
      }
    }).catchError((error) {
      log('Error fetching data: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
    generateComboKarakter();
  }

  void Edit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/UAS/Offer/EditOffer.php"),
        body: {
          'nama': _nama,
          'jenis': _jenis,
          'lokasi': _lokasi,
          'age': _age.toString(),
          'gender': _gender.toString(),
          'coat_length': _coat_length.toString(),
          'description': _description,
          'id': _id.toString(),
        });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sukses ubah data"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal ubah data"),
      ));
    }
  }

  Future<List> daftarKarakter() async {
    Map json;
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Karakter/KarakterList.php"),
        body: {'pet_id': widget.petID.toString()});

    if (response.statusCode == 200) {
      print(response.body);
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  void generateComboKarakter() {
    List<Karakter> karakter;
    var data = daftarKarakter();
    data.then((value) {
      karakter = List<Karakter>.from(value.map((i) {
        return Karakter.fromJSON(i);
      }));
      setState(() {
        comboKarakter = DropdownButton(
            dropdownColor: Colors.grey[100],
            hint: const Text("tambah karakter"),
            isDense: false,
            items: karakter.map((kar) {
              return DropdownMenuItem(
                value: kar.karakter_id,
                child: Text(kar.karakter_name, overflow: TextOverflow.visible),
              );
            }).toList(),
            onChanged: (value) {
              addKarakter(value);
            });
      });
    });
  }

  void addKarakter(karakter_id) async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/UAS/Karakter/AddKarakterPets.php"),
        body: {
          'karakter_id': karakter_id.toString(),
          'pets_id': widget.petID.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses menambah karakter')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Adoption Offer"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerNama,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pet',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nama = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Pet harus diisi!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerJenis,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Pet',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _jenis = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis Pet harus diisi!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerLokasi,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _lokasi = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi Pet harus diisi!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<int>(
                  value: _age,
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text("Young"),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text("Middle-Aged"),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("Old"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _age = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<int>(
                  value: _gender,
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text("Female"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<int>(
                  value: _coat_length,
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text("Short"),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text("Long"),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("Hairless"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _coat_length = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerDesc,
                  decoration: const InputDecoration(
                    labelText: 'Description Pet',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description Pet harus diisi!';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(
                  padding: EdgeInsets.all(10), child: Text('Karakter:')),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.karakter?.length ?? 0,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_pm!.karakter?[index]['karakter_name']),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: comboKarakter,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap Isian diperbaiki!'),
                        ),
                      );
                    } else {
                      Edit();
                    }
                  },
                  child: const Text('Submit Offer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
