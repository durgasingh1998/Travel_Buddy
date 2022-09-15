import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_buddy/details/hotel_detail.dart';
import 'package:travel_buddy/details/photo_details.dart';
import 'package:travel_buddy/screens/visited.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const DETAIL_ROUTE = '/detail-route';
  final Map<String, dynamic> infoDetails;

  const PlaceDetailsScreen({Key? key, required this.infoDetails})
      : super(key: key);

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int activeIndex = 0;
  final CarouselController _controller = CarouselController();
  var controller;
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> info = widget.infoDetails['args'];
    List<dynamic> imageList = info["images"];

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
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CarouselSlider.builder(
              carouselController: _controller,
              options: CarouselOptions(
                  height: 400,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  autoPlayInterval: Duration(seconds: 2),
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }),
              itemCount: imageList.length,
              itemBuilder: (context, index, realIndex) {
                final images = imageList[index];
                return buildImage(images.toString(), index);
              }),
          SizedBox(
            height: 20,
          ),
          buildIndicator(),
          SizedBox(
            height: 10,
          ),
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white),
              child: Text("${info["place_name"]}")),
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
                      onPressed: () {
                        showRating();
                      },
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
                          Navigator.pushNamed(context, VisitedScreen.ROUTE_NAME,
                              arguments: info['package']);
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
              child: Text("${info["about"]}"),
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
              child: Text(" ${info["bestTimeToVisit"]} "),
            )
          ]),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Ideal stay : ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              child: Text(" ${info["idealStay"]} "),
            ),
          ]),
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
              child: Text(" ${info["package"]} "),
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
          SizedBox(height: 250, child: PhotoDetails(docId: info["docId"])),
          SizedBox(
            height: 10,
          ),
          Container(),
          SizedBox(
            height: 60,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Recomended Hotels",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 250, child: HotelDetails(docId: info["docId"])),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Rating: $rating',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RatingBar.builder(
                initialRating: rating,
                maxRating: 1,
                itemSize: 32,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                updateOnDrag: true,
                onRatingUpdate: (rating) => setState(() {
                  this.rating = rating;
                }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildImage(String info, int index) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        color: Colors.grey,
        child: Image.network(
          info,
          fit: BoxFit.cover,
        ),
      );

  Widget buildIndicator() {
    return Container(
      alignment: Alignment.center,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: ("${["images"]}").length,
        onDotClicked: animateToSlide,
        effect: SlideEffect(
            dotWidth: 10,
            dotHeight: 10,
            activeDotColor: Colors.black,
            dotColor: Colors.grey),
      ),
    );
  }

  void animateToSlide(int index) => controller.animateToPage(index);

  void showRating() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Rate This Place'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please Leave a star rating',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  buildRating(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    updateRating();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ));
  }

  Widget buildRating() => RatingBar.builder(
        maxRating: 1,
        itemSize: 32,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      );

  updateRating() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('topCategories');

    await users
        .doc(widget.infoDetails['args']['docId'])
        .update({'rating': rating})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
