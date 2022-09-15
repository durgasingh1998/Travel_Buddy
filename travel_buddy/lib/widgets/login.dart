import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/screens/dashboard.dart';
import 'package:travel_buddy/session/constant_data.dart';
import 'package:travel_buddy/session/local_store.dart';
import 'package:travel_buddy/widgets/forgot_password.dart';
import 'package:travel_buddy/widgets/sign_up.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/Login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  final _fkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _fkey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 192, 95, 166),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Enter to a beautiful World",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Email',
                                  prefixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(Icons.email),
                                  ),
                                  labelStyle: TextStyle(color: Colors.grey)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                } else if (!value.contains('@' 'gmail.com')) {
                                  return 'Please enter valid Email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: TextFormField(
                              obscureText: isHiddenPassword,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Password',
                                  suffixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(
                                      Icons.visibility,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.key)),
                              validator: (val) =>
                                  (val!.isEmpty) ? 'Enter the password' : null,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                              onPressed: () => {
                                    Navigator.pushNamed(
                                      context,
                                      ForgotPassword.ROUTE_NAME,
                                    )
                                  },
                              child: Container(
                                alignment: (Alignment.bottomRight),
                                child: Text(
                                  "Forgot Password!",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 192, 95, 166),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_fkey.currentState!.validate()) {
                                proceed();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 192, 95, 166),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'If you dont have an account/',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.pushNamed(
                                            context,
                                            SignUpScreen.ROUTE_NAME,
                                          )
                                        },
                                    child: Text(
                                      'SignUp',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 192, 95, 166),
                                      ),
                                    )),
                              ])
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void proceed() async {
    try {
      final Credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      String userId = Credential.user!.uid;

      LocalStore store = LocalStore();
      store.storeData(ConstantData.UID, userId);

      Navigator.pushNamed(
        context,
        DashBoardScreen.ROUTE_NAME,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMsg('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMsg('Wrong password provided for that user.');
      }
    }
  }

  void showMsg(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
