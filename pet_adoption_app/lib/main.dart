// ================================ JIKA GAMBAR TIDAK BERJALAN ===========================================
// flutter run -d chrome --web-renderer html
// https://ubaya.me/phpMyAdmin/index.php?route=/database/structure&db=flutter_160421010

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/screen/browse.dart';
import 'package:pet_adoption_app/screen/login.dart';
import 'package:pet_adoption_app/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

String activeUser = "";
String activeRole = "";

Future<Map<String, String>> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  String role = prefs.getString("role") ?? '';
  return {'username': username, 'role': role};
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((Map<String, String> result) {
    if (result['username'] == '' && result['role'] == '') {
      runApp(const Login());
    } else {
      activeUser = result['username']!;
      activeRole = result['role']!;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption - Main',
      routes: {
        'Login': (context) => const Login(),
        'Register': (context) => const Register(),
        'MainScreen': (context) => const MainScreen(),
        'Browse': (context) =>  BrowsePage(),
        'Offer': (context) => const OfferPage(),
        'Adopt': (context) => const AdoptPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: activeUser == "" ? const Login() : const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("role");
    setState(() {
      activeUser = "";
      activeRole = "";
    });
    runApp(const MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: myDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Main Screen!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Browse');
              },
              child: Text('Go to Browse'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Offer');
              },
              child: Text('Go to Offer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Adopt');
              },
              child: Text('Go to Adopt'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        fixedColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: "Foto",
            icon: Icon(Icons.photo),
          ),
        ],
      ),
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(activeUser),
            accountEmail: Text(activeRole),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrSEirW23rUGMO8Kv_CkiiLyupMAeytR5nA0akQUT25JCzGDhDgfwSpx_R8sT_iY7sfzI&usqp=CAU"),
            ),
          ),
          ListTile(
            title: const Text('Browse'),
            leading: const Icon(Icons.search),
            onTap: () {
              Navigator.pushNamed(context, "Browse");
            },
          ),
          ListTile(
            title: const Text('Propose History'),
            leading: const Icon(Icons.catching_pokemon),
            onTap: () {
              Navigator.pushNamed(context, "");
            },
          ),
          ListTile(
            title: const Text('Adoption Offer'),
            leading: const Icon(Icons.list_alt),
            onTap: () {
              Navigator.pushNamed(context, "");
            },
          ),
          ListTile(
            title: Text(activeUser != "" ? "Logout" : "Login"),
            leading: const Icon(Icons.login),
            onTap: () {
              activeUser != "" ? doLogout() : Navigator.pushNamed(context, "Login");
            },
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Main Screen!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Browse');
              },
              child: Text('Go to Browse'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Offer');
              },
              child: Text('Go to Offer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Adopt');
              },
              child: Text('Go to Adopt'),
            ),
          ],
        ),
      ),
    );
  }
}



class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer'),
      ),
      body: Center(
        child: Text(
          'This is the Offer Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class AdoptPage extends StatelessWidget {
  const AdoptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt'),
      ),
      body: Center(
        child: Text(
          'This is the Adopt Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
