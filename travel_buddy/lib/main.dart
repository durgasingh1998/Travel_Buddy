import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/custom.dart';
import 'package:travel_buddy/details/feedCityDetails.dart';
import 'package:travel_buddy/firebase_options.dart';
import 'package:travel_buddy/screens/dashboard.dart';
import 'package:travel_buddy/details/place_details.dart';
import 'package:travel_buddy/screens/splash_screen.dart';
import 'package:travel_buddy/details/temple_details.dart';
import 'package:travel_buddy/screens/visited.dart';
import 'package:travel_buddy/session/about.dart';
import 'package:travel_buddy/details/feed_detail_screen.dart';
import 'package:travel_buddy/widgets/forgot_password.dart';
import 'package:travel_buddy/widgets/login.dart';
import 'package:travel_buddy/widgets/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Buddy',
      home: const SplashScreen(),
      scrollBehavior: MyCustomScrollBehavior(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == DashBoardScreen.ROUTE_NAME) {
          return MaterialPageRoute(builder: (_) => DashBoardScreen());
        } else if (settings.name == LoginScreen.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          );
        } else if (settings.name == SignUpScreen.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const SignUpScreen(),
          );
        } else if (settings.name == SplashScreen.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const SplashScreen(),
          );
        } else if (settings.name == ForgotPassword.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const ForgotPassword(),
          );
        } else if (settings.name == AboutScreen.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const AboutScreen(),
          );
        } else if (settings.name == PlaceDetailsScreen.DETAIL_ROUTE) {
          return MaterialPageRoute(
              builder: (_) => PlaceDetailsScreen(infoDetails: {
                    'args': settings.arguments,
                  }));
        } else if (settings.name == TempleDetails.DETAILS_ROUTE) {
          return MaterialPageRoute(
              builder: (_) => TempleDetails(infodetail: {
                    'args': settings.arguments,
                  }));
        } else if (settings.name == FeedDetailsScreen.DETAIL_ROUTE) {
          return MaterialPageRoute(
              builder: (_) => FeedDetailsScreen(infoDetails: {
                    'args': settings.arguments,
                  }));
        } else if (settings.name == VisitedScreen.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) =>
                VisitedScreen(package: {'args': settings.arguments}),
          );
        } else if (settings.name == FeedCityDetails.DETAILS_ROUTE) {
          return MaterialPageRoute(
              builder: (_) => FeedCityDetails(infodetail: {
                    'args': settings.arguments,
                  }));
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
