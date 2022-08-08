import 'package:flutter/material.dart';
import 'package:mono_log/data_models/authservice.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data_models/emaildomains.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  int authChoice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Authenticate",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Try one of these",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        authChoice = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: (authChoice == 0)
                            ? Colors.amber.shade400
                            : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: (authChoice == 0)
                                  ? Colors.white
                                  : Colors.teal.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "Assets/SvgAssets/guest.svg",
                              width: 24.0,
                              height: 24.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text("Guest"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        authChoice = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: (authChoice == 1)
                            ? Colors.amber.shade400
                            : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: (authChoice == 1)
                                  ? Colors.white
                                  : Colors.teal.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "Assets/SvgAssets/icon-verify.svg",
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text("Sign in"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        authChoice = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: (authChoice == 2)
                            ? Colors.amber.shade400
                            : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: (authChoice == 2)
                                  ? Colors.white
                                  : Colors.teal.shade50,
                              // color: Colors.teal.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "Assets/SvgAssets/icon-add.svg",
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text("Sign up"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: (authChoice == 0)
                ? AnonymousWidget(
                    authArg: _auth,
                  )
                : SignWidget(
                    indicator: authChoice,
                    authArg: _auth,
                  ),
          ),
        ],
      ),
    );
  }
}

class AnonymousWidget extends StatefulWidget {
  AnonymousWidget({Key? key, required this.authArg}) : super(key: key);
  AuthService authArg;

  @override
  State<AnonymousWidget> createState() => _AnonymousWidgetState();
}

class _AnonymousWidgetState extends State<AnonymousWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 100.0,
            color: Colors.amber,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
            child: Text(
              "Note: You're trying to sign in as a guest, the service will be continued as long as you don't sign out of the account. In such case, your data will be deleted forever from our servers. Don't worry, we'll give you an option to add an email to save your data permanently later.",
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.authArg.signinAnon();
            },
            child: const Text("Proceed as Guest"),
          ),
        ],
      ),
    );
  }
}

class SignWidget extends StatefulWidget {
  SignWidget({Key? key, required this.indicator, required this.authArg})
      : super(key: key);

  final int indicator; //1 for sign in, 2 for sign up
  AuthService authArg;

  @override
  State<SignWidget> createState() => _SignWidgetState();
}

class _SignWidgetState extends State<SignWidget> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  OutlineInputBorder errorBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  );

  OutlineInputBorder normalBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF823047), width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextFormField(
                validator: (value) {
                  String? result = "Enter a valid email address";
                  if (value != null) {
                    print(value);
                    int i = 0;
                    for (int i = 0; i < emailProviders.length; i++) {
                      if (value.endsWith(emailProviders[i])) {
                        result = null;
                        break;
                      } else {
                        result = "Enter a valid email address";
                      }
                    }
                  } else {
                    result = "Enter an email address";
                  }
                  return result;
                },
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                  helperText: " ",
                  enabledBorder: normalBorder,
                  focusedBorder: normalBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: errorBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextFormField(
                controller: password,
                validator: (value) {
                  if (value != null) {
                    return (value.length < 6)
                        ? "password has atleast 6 characters"
                        : null;
                  } else {
                    return "We need a password too!";
                  }
                },
                obscureText: true,
                obscuringCharacter: '◦',
                decoration: InputDecoration(
                  helperText: " ",
                  prefixIcon: const Icon(Icons.key_rounded),
                  hintText: "password",
                  enabledBorder: normalBorder,
                  focusedBorder: normalBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: errorBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState != null) {
                  if (formKey.currentState!.validate()) {
                    if (widget.indicator == 2) {
                      await widget.authArg
                          .signUpEmailandPassword(email.text, password.text);
                    } else {
                      await widget.authArg
                          .logInEmailandPassword(email.text, password.text);
                    }
                  } else {
                    print("Someone");
                  }
                }
              },
              child: Text((widget.indicator == 1)
                  ? "Proceed to sign in"
                  : "Proceed to sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
