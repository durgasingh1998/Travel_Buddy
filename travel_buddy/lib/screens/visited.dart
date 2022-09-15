import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class VisitedScreen extends StatefulWidget {
  final package;

  static const String ROUTE_NAME = '/VisitedScreen';

  const VisitedScreen({
    super.key,
    required this.package,
  });
  @override
  _VisitedScreenState createState() => _VisitedScreenState();
}

class _VisitedScreenState extends State<VisitedScreen> {
  late Razorpay razorpay;

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_XyFBEx6XxT6kEZ",
      "amount": num.parse(textEditingController.text) * 100,
      "name": "Travel Buddy",
      "description": "Payment for the places",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    print("Payment success");
    Toast.show("Payment success");
  }

  void handlerErrorFailure() {
    print("Payment error");
    Toast.show("Payment error");
  }

  void handlerExternalWallet() {
    print("External Wallet");
    Toast.show("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Razor Pay Tutorial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController..text,
              decoration: InputDecoration(
                hintText: " ${widget.package} ",
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              child: Text(
                "Pay Now",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openCheckout();
              },
            )
          ],
        ),
      ),
    );
  }
}
