import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_buddy/details/feed_details.dart';

class FeedDetailsScreen extends StatefulWidget {
  static const DETAIL_ROUTE = '/feeddetails-route';
  final Map<String, dynamic> infoDetails;

  const FeedDetailsScreen({
    Key? key,
    required this.infoDetails,
  }) : super(key: key);

  @override
  State<FeedDetailsScreen> createState() => _FeedDetailsScreenState();
}

class _FeedDetailsScreenState extends State<FeedDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> infos = widget.infoDetails['args'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Travel Buddy'),
          backgroundColor: Color.fromARGB(255, 192, 95, 166),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () async {
                await Share.share('Travel Buddy');
              },
            ),
          ],
        ),
        body: ListView(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: FeedDetails(docId: infos["docId"]))
        ]));
  }
}
