import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const String ROUTE_NAME = '/ForgotPassword';
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 192, 95, 166),
        title: Text("Reset Password"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              'Reset Link will be sent to your email id !',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                          fillColor: Colors.blue,
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15)),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        } else if (!value.contains('@' 'gmail.com')) {
                          return 'Please enter valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                });
                                resetPassword();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 192, 95, 166),
                            ),
                            child: Text(
                              'Send Email',
                              style: TextStyle(fontSize: 18.0),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 192, 95, 166),
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(
          'No user found for that email.',
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 192, 95, 166),
            content: Text(
              'No user found for that email',
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }
}
