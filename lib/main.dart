import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tacktick/video.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TackTick',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginFile();
  }

  void checkLoginFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/login.txt');
    if (await file.exists()) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Home() : Login();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.video_collection),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LentaScreen()),
                );
              },
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.monetization_on),
              onPressed: () {},
            ),
          ),
        ]),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                  hintText: 'Login',
                  helperText: 'Enter your login',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  hintText: 'Password',
                  helperText: 'Enter your password',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 32),
            ElevatedButton(
                onPressed: () {
                  saveLogin();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text('Войти'))
          ],
        ),
      ),
    );
  }

  void saveLogin() async {
    final dir = await getApplicationDocumentsDirectory();
    var loginFile = File('${dir.path}/login.txt');
    await loginFile
        .writeAsString('${_loginController.text}\n${_passwordController.text}');
  }
}

class LentaScreen extends StatelessWidget {
  List<String> uris = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < uris.length; i++)
              VideoPlayerScreen(uri: uris[i]),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.video_collection),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LentaScreen()),
                );
              },
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(Icons.monetization_on),
              onPressed: () {},
            ),
          ),
        ]),
      ),
    );
  }
}
