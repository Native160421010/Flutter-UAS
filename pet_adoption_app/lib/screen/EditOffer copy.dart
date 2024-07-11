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
import 'package:pet_adoption_app/class/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOffer extends StatefulWidget {
  final int idPet;
  const EditOffer(this.idPet, {super.key});
  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();

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

  int _runtime = 100;
  bool _allowDel = false;

  Pets? _pm;

  // List<Genre> genres = [];
  // Widget comboGenre = const Text('tambah genre');

  String? username = '';
  Future<void> LoadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
    setState(() {
      LoadUsername();
    });
  }

  Future<String> fetchData(int idPet) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421010/UAS/Propose/detailpropose.php"),
        body: {'id': idPet.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // Future<List> daftarGenre() async {
  //   Map json;
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.me/flutter/160421010/Genre/GenreList.php"),
  //       body: {'movie_id': widget.idMovie.toString()});

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     json = jsonDecode(response.body);
  //     return json['data'];
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }

  bacaData() {
    fetchData(widget.idPet).then((value) {
      Map json = jsonDecode(value);
      _pm = Pets.fromJson(json['data']);
      setState(() {
        _id = _pm!.id;
        _nama = _pm!.nama;
        _jenis = _pm!.jenis;
        _lokasi = _pm!.lokasi;
        _age = _pm!.age as int;
        _gender = _pm!.gender as int;
        _coat_length = _pm!.coat_length as int;
        _keterangan = _pm!.keterangan as int;
        _description = _pm!.description;

        _controllerNama.text = _nama;
        _controllerJenis.text = _jenis;
        _controllerLokasi.text = _lokasi;
        _controllerDesc.text = _description;
      });
    });
  }

  // void delete() async {
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.me/flutter/160421010/Movie/DeleteMovie.php"),
  //       body: {'id': _id.toString()}); // Convert int to string
  //   if (response.statusCode == 200) {
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       if (!mounted) return;
  //       setState(() {
  //         _allowDel = false;
  //       });
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Sukses Menghapus Data')));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error')));
  //     throw Exception('Failed to read API');
  //   }
  // }

  // void addGenre(genre_id) async {
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.me/flutter/160421010/Genre/AddMovieGenre.php"),
  //       body: {
  //         'genre_id': genre_id.toString(),
  //         'movie_id': widget.idMovie.toString()
  //       });
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Sukses menambah genre')));
  //       setState(() {
  //         bacaData();
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }

  // void delGenre(genre_id) async {
  //   final response = await http.post(
  //       Uri.parse(
  //           "https://ubaya.me/flutter/160421010/Genre/DeleteMovieGenre.php"),
  //       body: {
  //         'movie_id': widget.idMovie.toString(),
  //         'genre_id': genre_id.toString()
  //       });
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Sukses menghapus genre')));
  //       setState(() {
  //         bacaData();
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }

  // void generateComboGenre() {
  //   //widget function for city list
  //   List<Genre> genres;
  //   var data = daftarGenre();
  //   data.then((value) {
  //     genres = List<Genre>.from(value.map((i) {
  //       return Genre.fromJSON(i);
  //     }));
  //     comboGenre = DropdownButton(
  //         dropdownColor: Colors.grey[100],
  //         hint: const Text("tambah genre"),
  //         isDense: false,
  //         items: genres.map((gen) {
  //           return DropdownMenuItem(
  //             value: gen.genre_id,
  //             child: Column(children: <Widget>[
  //               Text(gen.genre_name, overflow: TextOverflow.visible),
  //             ]),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           addGenre(value);
  //         });
  //   });
  // }

  void Edit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/Movie/EditMovie.php"),
        body: {
          'id': _id.toString(),
          'nama': _nama,
          'jenis': _jenis,
          'keterangan': _keterangan.toString(),
          'description': _description,
          'lokasi': _lokasi,
          'age': _age.toString(),
          'gender': _gender.toString(),
          'coat_length': _coat_length.toString(),
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
  }
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


