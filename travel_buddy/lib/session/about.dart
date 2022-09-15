import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String ROUTE_NAME = '/About';
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Buddy"),
        backgroundColor: Color.fromARGB(255, 192, 95, 166),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "“Travel Buddy” is a travel guide application. It is flutter application which works like Android , IOS and Web Applications It provides online travel services including hotel details.Travel guide app gives the information about beautiful places for Visiting across India.You can get information about the places sitting at home and you can also book to visit.It gives the idea , which time is best for visiting and how much time is sufficient for visiting selected places.It is an Flutter Application so, it works as an Android Application, IOS Application and Web Application also.It is an user friendly application.You can get information about the places sitting at home and you can also book this places to visit.It gives the idea which time is best for visiting and how much time is sufficient for visiting selected places.It is affordable for all people.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
