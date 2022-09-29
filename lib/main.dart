import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mono_log/data_models/authservice.dart';
import 'package:mono_log/data_models/user.dart';
import 'package:mono_log/wrapper.dart';
import 'package:provider/provider.dart';

//TODO: Maybe Tasks too
//TODO: Date in note-previews too!
//TODO: A search function
//TODO: Multiple themes
//TODO: Maybe markdown text
//TODO: Link option

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
        title: 'Made with ❤',
        theme: ThemeData(
            primaryColor: Colors.lime,
            primaryColorDark: Colors.black,
            primarySwatch: Colors.lime,
            fontFamily: "Raleway",
            brightness: Brightness.light),
        darkTheme: ThemeData(
            primaryColor: Colors.black,
            primaryColorDark: Colors.lime,
            primarySwatch: Colors.lime,
            fontFamily: "Raleway",
            brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
      ),
    );
  }
}
