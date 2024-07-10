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

  int _id = 0;
  String _nama = "";
  String _jenis = "";
  int _keterangan = 0;
  String _description = "";
  String username_reviewee = "";

  // bool _allowDel = false;
  final _controllerNama = TextEditingController();
  final _controllerJenis = TextEditingController();
  final _controllerDesc = TextEditingController();

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('username') ?? '';
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421010/UAS/Offer/NewOffer.php"),
        body: {
          'nama': _nama,
          'jenis': _jenis,
          'keterangan': _keterangan,
          'description': _description,
          'username_reviewee': username_reviewee,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        setState(() {
          _id = json['id'];
          // _allowDel = true;

          _nama = "";
          _jenis = "";
          _description = "";

          _controllerNama.clear();
          _controllerJenis.clear();
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

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    print(username_reviewee);
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
                    controller: _controllerDesc,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pet Description harus diisi!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: const Text('Submit Offer'),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: Visibility(
              //     visible: _allowDel,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         delete();
              //       },
              //       child: const Text('Delete Previous Data'),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
