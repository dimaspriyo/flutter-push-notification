import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> sendPushNotification(String title, String body,
    FirebaseMessaging messaging) async {
  String token = "";
  await messaging.getToken().then((value) =>
  {
    if (value != null) {token = value}
  });

  print("Token:" + token);
  final response = await http.post(Uri.parse("http://192.168.1.24:8080/send"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "device_token": token,
        "title": title,
        "body": body
      }));

  bool result = false;
  if (response.statusCode == 200) {
    result = true;
  } else {
    throw Exception("System Error");
  }

  return result;
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  late FirebaseApp firebaseApp;

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  void initFirebase() async {
    firebaseApp = await Firebase.initializeApp();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message Received");

      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.notification!.title!),
          content: Text(message.notification!.body!),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],

        );
      });
    });
  }

  @override
  void initState() {
    initFirebase();
    messaging = FirebaseMessaging.instance;
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Push Notification Title ...'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Push Notification Message ...'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  sendPushNotification(titleController.text, bodyController.text, messaging);
                },
                child: Text("Send Notification")),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
