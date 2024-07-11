import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewOffer extends StatefulWidget {
  const NewOffer({super.key});
  @override
  State<NewOffer> createState() => _NewOfferState();
}

class _NewOfferState extends State<NewOffer> {
  final _formKey = GlobalKey<FormState>();

  late SharedPreferences prefs;
  String username_reviewee = '';

  int _id = 0;
  String _nama = "";
  String _jenis = "";
  final int _keterangan = 0;
  String _description = "";
  String _lokasi = "";
  int _age = 0;
  int _gender = 0;
  int _coat_length = 0;
  final _controllerNama = TextEditingController();
  final _controllerJenis = TextEditingController();
  final _controllerLokasi = TextEditingController();
  final _controllerDesc = TextEditingController();

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/UAS/Offer/NewOffer.php"),
        body: {
          'nama': _nama,
          'jenis': _jenis,
          'lokasi': _lokasi,
          'age': _age.toString(),
          'gender': _gender.toString(),
          'coat_length': _coat_length.toString(),
          'keterangan': _keterangan.toString(),
          'description': _description,
          'username_reviewee': username_reviewee,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        setState(() {
          _id = json['id'];

          _nama = "";
          _jenis = "";
          _lokasi = "";
          _description = "";
          _age = 0;
          _gender = 0;
          _coat_length = 0;

          _controllerNama.clear();
          _controllerJenis.clear();
          _controllerLokasi.clear();
          _controllerDesc.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  Future<void> _loadUsername() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username_reviewee = prefs.getString('username') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Adoption Offer"),
        ),
        body: Form(
          key: _formKey,
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
                      _nama = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Pet harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerJenis,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Pet',
                    ),
                    onChanged: (value) {
                      _jenis = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis Pet harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerLokasi,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi',
                    ),
                    onChanged: (value) {
                      _lokasi = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi Pet harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
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
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
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
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
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
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerDesc,
                    decoration: const InputDecoration(
                      labelText: 'Description Pet',
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description Pet harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Harap Isian diperbaiki!')));
                    } else {
                      submit();
                    }
                  },
                  child: const Text('Submit Offer'),
                ),
              ),
            ],
          ),
        ));
  }
}
