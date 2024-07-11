// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:pet_adoption_app/main.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption - Register',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

String username = "";
String password = "";
String passwordCon = "";
String errorRegister = "";

class _RegisterState extends State<RegisterForm> {
  void doRegister() async {
    if (password == passwordCon) {
      final response = await http.post(
          Uri.parse("https://ubaya.me/flutter/160421010/UAS/User/Register.php"),
          body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("username", json['username']);
          main();
        } else {
          setState(() {
            errorRegister = "json['message']";
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Login'),
        ),
        body: Container(
          height: 500,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter valid username',
                ),
                onChanged: (v) {
                  username = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                onChanged: (v) {
                  password = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter confirmation password'),
                onChanged: (v) {
                  passwordCon = v;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      doRegister();
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text("Have an account? Login."),
            )
          ]),
        ));
  }
}
 