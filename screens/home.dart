import 'package:flutter/material.dart';
import 'package:mono_log/data_models/authservice.dart';
import 'package:mono_log/data_models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.userID}) : super(key: key);
  final CustomUser userID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();

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
      body: SafeArea(child: Container()),
    );
  }
}
