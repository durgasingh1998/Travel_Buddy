import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/widgets/login.dart';
import 'package:travel_buddy/widgets/custom_input_field.dart';

class SignUpScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/SignUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isHiddenPassword = true;
  bool hiddenPassord = true;
  final _fkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _ConfirmpasswordController = TextEditingController();
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
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Create an Account",
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
                  flex: 3,
                  child: Container(
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
                            CustomInputField(
                              labelText: 'Name',
                              txtController: _nameController,
                              iconValue: Icons.person,
                              type: TextInputType.name,
                              visible: false,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Email',
                                  prefixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(Icons.email),
                                  ),
                                ),
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
                              height: 5,
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'Password',
                                    suffixIcon: InkWell(
                                      onTap: _togglePasswordView,
                                      child: Icon(
                                        Icons.visibility,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.key)),
                                validator: (val) => (val!.isEmpty)
                                    ? 'Enter the password'
                                    : null,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: TextFormField(
                                obscureText: hiddenPassord,
                                controller: _ConfirmpasswordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'Confirm Password',
                                    suffixIcon: InkWell(
                                      onTap: _togglePassword,
                                      child: Icon(
                                        Icons.visibility,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.key)),
                                validator: (val) => (val!.isEmpty)
                                    ? 'Enter the confirm password'
                                    : null,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
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
                                child: Text("SignUp")),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account/',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()))
                                          },
                                      child: Text(
                                        'Login',
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
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> proceed() async {
    if (_passwordController.text != _ConfirmpasswordController.text) {
      showMsg("password didn't match");
    } else {
      try {
        final Credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        String userId = Credential.user!.uid;
        addtoDB(userId);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showMsg('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showMsg('The account already exists for that email.');
        }
      } catch (e) {
        showMsg(e.toString());
      }
    }
  }

  void showMsg(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e)),
    );
  }

  void addtoDB(String userId) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('accounts');

    await userCollection
        .doc(userId)
        .set({
          'email': _emailController.text,
          'password': _passwordController.text,
        })
        .then((_) => Navigator.pushNamed(
              context,
              LoginScreen.ROUTE_NAME,
            ))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => showMsg('Failed to add user: $error'));
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void _togglePassword() {
    setState(() {
      hiddenPassord = !hiddenPassord;
    });
  }
}
