import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:otlob/screens/main/main_screens/myOrder.dart';
import 'package:otlob/services/paypal/services.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'dart:convert' as convert;
import 'package:otlob/value/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  Payment(
      {Key? key,
      required this.meal,
      required this.price,
      required this.id,
      required this.count,
      required this.resID,
      required this.resCount,
      required this.clientId,
      required this.secret})
      : super(key: key);
  final String meal;
  final String price;
  final String id;
  final String resID;
  final int resCount;
  final int count;
  final String clientId;
  final String secret;
  @override
  State<Payment> createState() => _PaymentState();
}

Random _rnd = Random();
const _chars = '1234567890';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _PaymentState extends State<Payment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String checkoutUrl = '';
  late String executeUrl;
  late String accessToken;
  Services services = Services();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "ILS ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "ILS"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';
  String domain = "https://api.sandbox.paypal.com";
//  String domain = "https://api.paypal.com"; // for production mode

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        var client = BasicAuthClient(widget.clientId, widget.secret);
        var response = await client.post(
            Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
        if (response.statusCode == 200) {
          final body = convert.jsonDecode(response.body);
          try {
            accessToken = body["access_token"];
            final transactions = getOrderParams();
            final res =
                await services.createPaypalPayment(transactions, accessToken);
            if (res != null) {
              setState(() {
                checkoutUrl = res["approvalUrl"]!;
                executeUrl = res["executeUrl"]!;
              });
            }
          } catch (e) {
            getSheetError(e.toString());
            Navigator.pop(context);
          }
        }
      } catch (e) {
        rethrow;
      }
    });
  }

  // item name, price and quantity
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    String shippingCost = '0';
    int shippingDiscountCost = 0;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.price,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.price,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != '') {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                // services.executePayment(executeUrl, payerID, accessToken);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => myOrderScreen()));
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'myOrders': {
                    widget.id: {
                      'orderStatus': 'paid',
                      'orderTimeLastUpdate': DateTime.now()
                    }
                  },
                  'countOrder': (widget.count + 1)
                }, SetOptions(merge: true));
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  widget.id: {
                    'orderStatus': 'paid',
                    'orderTimeLastUpdate': DateTime.now()
                  },
                }, SetOptions(merge: true));

                FirebaseFirestore.instance
                    .collection('notifications')
                    .doc('orders')
                    .set({
                  'NO-' + getRandomString(12): {
                    'restaurantID': widget.resID,
                    'mealsName': widget.meal.toString(),
                    'time': DateTime.now(),
                    'total': widget.price.toString(),
                    'paymentType': 'paypal',
                    'clientID': AppPreferences().getUserDataAsMap()['uid'],
                    'orderID': widget.id,
                    'orderStatus': 'new',
                  }
                }, SetOptions(merge: true)).then((value) {});

                FirebaseFirestore.instance
                    .collection('restaurant')
                    .doc(widget.resID)
                    .set({'countOrder': (widget.resCount + 1)},
                        SetOptions(merge: true));
                getSheetSucsses(
                    'تم دفع الطلب بنجاح, شكراً لثقتكم\n طلبك بطريقه اليك, يوماً سعيد');
              } else {
                Navigator.of(context).pop();
                getSheetSucsses(
                    'عذراً حدث خطأ ما يرجى المحاولة\n لاحقاً او التواصل مع فريق الدعم');
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
