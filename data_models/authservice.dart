import 'package:firebase_auth/firebase_auth.dart';
import 'package:mono_log/data_models/user.dart';

class AuthService {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  //create CustomUser from SignedUser User
  CustomUser? _userfromFireUser(User? user) {
    return (user != null)
        ? CustomUser(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            isAnonymous: user.isAnonymous,
            emailVerified: user.emailVerified,
            createdOn: user.metadata.creationTime,
            lastSignTime: user.metadata.lastSignInTime)
        : null;
  }

  //set up auth stream
  Stream<CustomUser?> get userCred {
    return _instance
        .authStateChanges()
        .map((User? user) => _userfromFireUser(user));
  }

  //sign in anon
  Future signinAnon() async {
    try {
      UserCredential result = await _instance.signInAnonymously();
      if (result.user != null) {
        print(result);
        User user = result.user!;
        print(user.uid);
        return _userfromFireUser(user);
      }
    } catch (e) {
      print('error signing in');
      print(e.toString());
      return null;
    }
  }

  //sign up with email & password
  Future signUpEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _instance.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        User user = result.user!;
        print(user.uid);
        return _userfromFireUser(user);
      }
    } catch (e) {
      print('error signing in');
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future logInEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _instance.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        User user = result.user!;
        print(user.uid);
        return _userfromFireUser(user);
      }
    } catch (e) {
      print('error signing in');
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    await _instance.signOut();
  }
}
