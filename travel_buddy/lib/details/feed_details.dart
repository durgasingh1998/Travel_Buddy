import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_buddy/screens/visited.dart';

class FeedDetails extends StatefulWidget {
  final String docId;
  FeedDetails({Key? key, required this.docId}) : super(key: key);

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.docId)
        .collection("march")
        .get();

    print('Firebase users ${users}');

    return FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("No Data to Display");
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot ds) {
            Map<String, dynamic> feed =
                ds.data()! as Map<String, dynamic>; // firestore indivi data

            return GestureDetector(
              onTap: () {
                print('Firebase feed data $feed');
                print('Dilaog');

                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: true,
                    context: context,
                    builder: (BuildContext context) =>
                        dialogWidget(infoe: feed));
                // Navigator.pushNamed(context, FeedCityDetails.DETAILS_ROUTE,
                //     arguments: {
                //       'weight': 'Q0',
                //       'height': 'heights',
                //     });
                Navigator.pushNamed(context, '/feedCityDetails_route',
                    arguments: {
                      'weight': 'count',
                      'height': 'heights',
                    });
              },
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
                          feed['place_image'].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('${feed['place_name']}')
                    ],
                  )),
            );
          }).toList());
        },
        future: users);
  }

  Widget dialogWidget({required Map<String, dynamic> infoe}) => Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 48,
            ),
            AppBar(
              title: Text("Travel Buddy"),
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
            CarouselSlider.builder(
                carouselController: CarouselController(),
                options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    autoPlayInterval: Duration(seconds: 2),
                    onPageChanged: (index, reason) {
                      // setState(() {
                      //   activeIndex = index;
                      // });
                    }),
                itemCount: infoe['images'].length,
                itemBuilder: (context, index, realIndex) {
                  final images = infoe['images'][index];

                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    color: Colors.grey,
                    child: Image.network(
                      images.toString(),
                      fit: BoxFit.cover,
                    ),
                  );
                  // return buildImage(images.toString(), index);
                }),
            // SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: AnimatedSmoothIndicator(
            //     activeIndex: activeIndex,
            //     count: ("${["images"]}").length,
            //     onDotClicked: controller.animateToPage,
            //     effect: SlideEffect(
            //         dotWidth: 10,
            //         dotHeight: 10,
            //         activeDotColor: Colors.black,
            //         dotColor: Colors.grey),
            //   ),
            // ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 3,
                      color: Color.fromARGB(255, 192, 95, 166),
                    )),
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color.fromARGB(255, 161, 154, 152),
                        ),
                        icon: Icon(Icons.star),
                        label: Text(
                          'RATE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color.fromARGB(255, 37, 35, 35),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 3,
                        color: Color.fromARGB(255, 192, 95, 166),
                      )),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, VisitedScreen.ROUTE_NAME);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Color.fromARGB(255, 161, 154, 152),
                          ),
                          icon: Icon(Icons.bookmark),
                          label: Text(
                            'VISITED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 37, 35, 35),
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "About",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text("${infoe["about"]}"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Best time to Visit : ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(" ${infoe["bestTimeToVisit"]} "),
              )
            ]),
            SizedBox(
              height: 10,
            ),
            Row(children: []),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Package : ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(" ${infoe["package"]} "),
              )
            ]),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Photos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: infoe['images'].length,
                itemBuilder: (context, index) => FittedBox(
                    fit: BoxFit.cover,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.network("${infoe['images'][index]}"),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      );
}
