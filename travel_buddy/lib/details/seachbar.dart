import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:travel_buddy/details/place_details.dart';

class SearchBar extends SearchDelegate {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("topCategories");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //fetch data
            print(snapshot.data);
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['place_name']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String place_name = data.get('place_name');
                  final String place_image = data.get('place_image');
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, PlaceDetailsScreen.DETAIL_ROUTE);
                    },
                    title: Text(place_name),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(place_image)),
                  );
                })
              ],
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    throw UnimplementedError();
  }
}
