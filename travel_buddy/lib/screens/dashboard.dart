import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_buddy/details/place_details.dart';
import 'package:travel_buddy/details/temple_details.dart';
import 'package:travel_buddy/session/NavBar.dart';
import 'package:travel_buddy/details/feed_detail_screen.dart';

class DashBoardScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/DashBoardScreen';
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int activeIndex = 0;
  final CarouselController _controller = CarouselController();

  List<String> urlImage = [
    'https://img.traveltriangle.com/blog/wp-content/uploads/2018/11/Cover-for-best-places-to-visit-in-July-in-the-world.jpg',
    'https://www.holidify.com/images/attr_square/1020.jpg',
    'https://www.holidify.com/images/bgImages/PARIS.jpg',
    'https://www.fabhotels.com/blog/wp-content/uploads/2019/02/600x400-49-1280x720.jpg',
    'https://media.timeout.com/images/105859745/750/422/image.jpg',
  ];

  List<Map<String, dynamic>> topCategories = [];
  List<Map<String, dynamic>> FamousTemples = [];
  List<Map<String, dynamic>> Feed = [];
  bool searchState = false;

  @override
  void initState() {
    fetchDataList();
    fetchTempleList();
    fetchFeedList();
    super.initState();
  }

  var controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: 1550,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: SizedBox(
                  height: 400,
                  child: CarouselSlider.builder(
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
                      itemCount: urlImage.length,
                      itemBuilder: (context, index, realIndex) {
                        final urlImages = urlImage[index];
                        return buildImage(urlImages, index);
                      }),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              buildIndicator(),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey, width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 20,
                          offset: Offset(0, 10))
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        onChanged: (text) {
                          print('Text $text');
                          SearchMethod(text);
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: !searchState
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchState = !searchState;
                                  });
                                },
                                icon: Icon(Icons.search))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchState = !searchState;
                                  });
                                },
                                icon: Icon(Icons.cancel)))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Top Categories',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(child: displaytopCategories()),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Famous Temples In India",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ),
              Expanded(child: displayFamousTemples()),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Feed',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 2, child: displayFeedData()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 14,
        ),
        color: Colors.grey,
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: urlImage.length,
      onDotClicked: animateToSlide,
      effect: SlideEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.black,
          dotColor: Colors.grey),
    );
  }

  void animateToSlide(int index) => controller.animateToPage(index);

  Widget displaytopCategories() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: topCategories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PlaceDetailsScreen.DETAIL_ROUTE,
                arguments: topCategories[index]);
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
                      topCategories[index]['place_image'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('${topCategories[index]['place_name']}')
                ],
              )),
        );
      },
    );
  }

  Widget displayFamousTemples() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: FamousTemples.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, TempleDetails.DETAILS_ROUTE,
                arguments: FamousTemples[index]);
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
                      FamousTemples[index]['place_image'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('${FamousTemples[index]['place_name']}')
                ],
              )),
        );
      },
    );
  }

  Widget displayFeedData() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: Feed.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, FeedDetailsScreen.DETAIL_ROUTE,
                arguments: Feed[index]);
          },
          child: Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: 400,
                    child: Image.network(
                      Feed[index]['place_image'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('${Feed[index]['place_name']}')
                ],
              )),
        );
      },
    );
  }

  fetchDataList() async {
    Map<String, dynamic> map;
    List<Map<String, dynamic>> list = [];
    await FirebaseFirestore.instance
        .collection('topCategories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        map = {
          'place_name': doc['place_name'],
          'place_image': doc['place_image'],
          'about': doc['about'],
          'idealStay': doc['idealStay'],
          'package': doc['package'],
          'bestTimeToVisit': doc['bestTimeToVisit'],
          'images': doc['images'],
          'docId': doc.id,
        };
        list.add(map);
      });
    });
    setState(() {
      tempTopCategoriesList = list;
      topCategories = list;
    });
  }

  fetchTempleList() async {
    Map<String, dynamic> map;
    List<Map<String, dynamic>> list = [];
    await FirebaseFirestore.instance
        .collection('FamousTemples')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        map = {
          'place_name': doc['place_name'],
          'place_image': doc['place_image'],
          'about': doc['about'],
          'idealStay': doc['idealStay'],
          'package': doc['package'],
          'bestTimeToVisit': doc['bestTimeToVisit'],
          'images': doc['images'],
          'docId': doc.id,
        };
        list.add(map);
      });
    });
    setState(() {
      FamousTemples = list;
    });
  }

  fetchFeedList() async {
    Map<String, dynamic> map;
    List<Map<String, dynamic>> list = [];
    await FirebaseFirestore.instance
        .collection('Feed')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        map = {
          'place_name': doc['place_name'],
          'place_image': doc['place_image'],
          'docId': doc.id,
        };
        list.add(map);
      });
    });
    setState(() {
      Feed = list;
    });
  }

  List<Map<String, dynamic>> tempTopCategoriesList = [];

  void SearchMethod(String query) {
    if (query.isNotEmpty) {
      setState(() {
        topCategories = tempTopCategoriesList
            .where((element) =>
                element['place_name']
                    .toString()
                    .toLowerCase()
                    .contains(query) &&
                element['place_name']
                    .toString()
                    .toLowerCase()
                    .startsWith(query))
            .toList();
      });
    } else {
      setState(() {
        topCategories = tempTopCategoriesList;
      });
    }
  }
}
