import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_buddy/session/about.dart';

import 'package:travel_buddy/widgets/login.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String imagePath =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  late File imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          imageProfile(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pushNamed(context, AboutScreen.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () async {
              await Share.share('Travel Buddy');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('SignOut'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, LoginScreen.ROUTE_NAME);
            },
          )
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 80.0, backgroundImage: Image.file(File(imagePath)).image),
          Positioned(
              bottom: 20.0,
              right: 20.0,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 192, 95, 166),
                  size: 28.0,
                ),
              ))
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: 20,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 192, 95, 166),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 192, 95, 166),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      imagePath = pickedFile!.path;
      // imageFile = pickedFile![];
    });
  }
}
