import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhotoDetails extends StatelessWidget {
  final String docId;
  PhotoDetails({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance
        .collection('topCategories')
        .doc(docId)
        .collection("photos")
        .get();

    return FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("No Data to Display");
          }

          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot ds) {
                Map<String, dynamic> hotels =
                    ds.data()! as Map<String, dynamic>; // firestore indivi data

                return GestureDetector(
                  onTap: () {},
                  child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 300,
                            child: Image.network(
                              hotels['place_image'].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('${hotels['place_name']}')
                        ],
                      )),
                );
              }).toList());
        },
        future: users);
  }
}
