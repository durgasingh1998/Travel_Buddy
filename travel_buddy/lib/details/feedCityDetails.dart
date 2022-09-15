import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_buddy/screens/visited.dart';

class FeedCityDetails extends StatefulWidget {
  static const DETAILS_ROUTE = '/feedCityDetails_route';
  final Map<String, dynamic> infodetail;

  const FeedCityDetails({Key? key, required this.infodetail}) : super(key: key);

  @override
  State<FeedCityDetails> createState() => _FeedCityDetailsState();
}

class _FeedCityDetailsState extends State<FeedCityDetails> {
  int activeIndex = 0;
  final CarouselController _controller = CarouselController();
  var controller;
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print('arguments ${arguments['FeedDetails']}');
    Map<String, dynamic> infos = widget.infodetail['args'];
    List<dynamic> imageList = infos["images"];
    return Scaffold(
      appBar: AppBar(
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
              child: Text("${infos["about"]}"),
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
              child: Text(" ${infos["bestTimeToVisit"]} "),
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
              child: Text(" ${infos["package"]} "),
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
              itemCount: infos['images'].length,
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
                          Image.network("${infos['images'][index]}"),
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

  Widget buildImage(String infos, int index) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        color: Colors.grey,
        child: Image.network(
          infos,
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
}
