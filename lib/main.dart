import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tacktick/video.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _login = '';
  String _password = '';
  String _name = "";
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/login.txt');

    if (await file.exists()) {
      final lines = await file.readAsLines();

      setState(() {
        _login = lines[0];
        _password = lines[1];
        _name = lines[2];
        _isPro = lines[3] == 'True';
      });
    }
  }

  void Send() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    final bytes = await video?.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://311ea4bb-6d4a-4082-af4c-d20a29d24cd3-00-1hanzs5gce23m.picard.replit.dev/upload'),
    );

    request.files.add(http.MultipartFile.fromBytes('video', bytes as List<int>,
        filename: 'video.mp4'));

    var response = await request.send();
  }

  _pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final directory = await getApplicationDocumentsDirectory();
      final name = video.path.split('/').last;
      final filePath = '${directory.path}/$name';
      File(video.path).copy(filePath);
      Send();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              height: 300,
              width: 300,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                '${_name}',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              height: 100,
              width: 300,
              margin: EdgeInsets.only(top: 100),
              child: TextButton(
                  child: Text('Upload video',
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  onPressed: () {
                    _pickVideo();
                  }),
            ),
          ],
        ),
      )),
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
  final _nameController = TextEditingController();

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
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: 'Name',
                  helperText: 'Enter your name',
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
    await loginFile.writeAsString(
        '${_loginController.text}\n${_passwordController.text}\n${_nameController.text}\nFalse');
  }
}

class LentaScreen extends StatelessWidget {
  List<String> uris = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://video.wixstatic.com/video/dcaf2d_695a08e986db4fb8b3cc1c76967b9ff3/1080p/mp4/file.mp4',
    'https://video.wixstatic.com/video/dcaf2d_719f6b8faa19476aa842379e36099d7f/480p/mp4/file.mp4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < uris.length; i++)
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: VideoPlayerScreen(uri: uris[i]),
              ),
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
