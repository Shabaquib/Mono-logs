import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mono_log/data_models/authservice.dart';
import 'package:mono_log/data_models/user.dart';
import 'package:mono_log/screens/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().userCred,
      initialData: null,
      child: MaterialApp(
        title: 'Mono-logs',
        theme: ThemeData(primarySwatch: Colors.lime, fontFamily: "RedHat"),
        home: const Wrapper(),
      ),
    );
  }
}
