import 'package:flutter/material.dart';
import 'package:mono_log/data_models/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mono_log/data_models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.userID}) : super(key: key);
  final CustomUser userID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService auth = AuthService();
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_open_rounded),
        centerTitle: true,
        title: const Text(
          "Mono-Log",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete_rounded),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: cloudInstance.collection(widget.userID.uid).get(),
          builder: (BuildContext ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data!.size == 0) {
                cloudInstance.collection(widget.userID.uid).add({
                  "topic": "Welcome",
                  "content":
                      "Welcome to Mono-Logs. Here you can add, edit or delete your logs",
                  "created-on": DateTime.now(),
                  "colormap": {"Red": 226, "Green": 234, "Blue": 252},
                });
              }
              return DocumentStream(
                userId: widget.userID.uid,
              );
            } else {
              return Container(); //add a spinkit
              // return DocumentStream();   return a simple scaffold
            }
          }),
    );
  }
}

class DocumentStream extends StatefulWidget {
  const DocumentStream({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<DocumentStream> createState() => _DocumentStreamState();
}

class _DocumentStreamState extends State<DocumentStream> {
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: cloudInstance.collection(widget.userId).snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshots) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ));
        });
  }
}
