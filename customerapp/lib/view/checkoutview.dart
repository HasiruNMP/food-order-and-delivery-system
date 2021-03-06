import 'dart:async';

import 'package:advance_notification/advance_notification.dart';

import 'package:customerapp/view/makepayment.dart';
import 'package:customerapp/view/ordercompleteview.dart';
import 'package:customerapp/view/setlocationview.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:customerapp/global.dart' as global;
import 'package:twilio_flutter/twilio_flutter.dart';
import '../api/apiservice.dart';
import '../controller/cart.dart';
import 'homeview.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutView extends StatefulWidget {
  LatLng delLoc;
  CheckoutView(this.delLoc, {Key? key}) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  double quantityPrice = 0;
  String fname = 'null';
  String lname = 'null';
  String phoneNo = 'null';
  late String totalPrice;
  late String items;
  late int orderNum;
  late String orderId;
  //late Timestamp timeStamp;
  //LatLng location = LatLng(0.0, 0.0);
  List<String> itemsArr = [];
  late Razorpay _razorpay;

  //map variables
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng lastTap;
  late CameraPosition initLocation;
  var user;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    CallApi();
    totalPrice = Cart.totalPrice.toString();

    itemsArr = [
      for (int i = 0; i < Cart.basketItems.length; i++)
        " ${Cart.basketItems[i].name} * ${Cart.basketItems[i].quantity}  Rs.${Cart.basketItems[i].quantity * Cart.basketItems[i].price}"
    ];
    print(itemsArr);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //  msg: "SUCCESS:" + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    // IncreaseOrderNumbers();
    // AddOrderDetails('Paid');
    // AddEachItems();

    //Navigator.pop(context);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrderCompleted(widget.delLoc, Cart.totalPrice, fname, phoneNo)),
      );
      Cart.PaymentStates();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failed:" +
            response.code.toString() +
            "-" +
            response.message!,
        toastLength: Toast.LENGTH_SHORT);
    print(response.code.toString());
    print(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET:" + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    double lastprice = double.parse(totalPrice) * 100;
    var options = {
      'key': 'rzp_test_1G3GSxR1F87q2o',
      'amount': lastprice.toString(),
      "currency": "LKR",
      //"orderid": orderId,
      "international": true,
      "method": "card",
      //    "email": userEmail,
      "contact": phoneNo,
      'name': '$fname $lname',
      'description': itemsArr,
      // 'send_sms_hash': true,
      'prefill': {'contact': phoneNo, 'email': 'rakshitha@gmail.com'},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> CallApi() async {
    user = await APIService.getUserDetails(global.phoneNo);
    updateUi(user);
  }

  void updateUi(dynamic user) {
    setState(() {
      fname = user[0]["FirstName"];
      lname = user[0]["LastName"];
      phoneNo = user[0]["Phone"];
    });
  }

  void Pay() {
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1219946", // Replace your Merchant ID
      "notify_url": "http://sample.com/notify",
      "order_id": orderId,
      "items": itemsArr,
      "amount": totalPrice,
      "currency": "LKR",
      "first_name": fname,
      "last_name": lname,
      "email": "",
      "phone": phoneNo,
      "address": "",
      "city": "",
      "country": "Sri Lanka",
      // "delivery_address": "No. 46, Galle road, Kalutara South",
      // "delivery_city": "Kalutara",
      // "delivery_country": "Sri Lanka",
      // "custom_1": "",
      // "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");

      setState(() {
        Cart.EmptyCart();
      });
      Navigator.pop(context);
      setState(() {
        Navigator.pushReplacementNamed(context, 'home');
        // Navigator.popUntil(context, ModalRoute.withName('home'));
        const AdvanceSnackBar(
          message: "Payment Completed Successfully!",
          mode: Mode.ADVANCE,
          duration: Duration(seconds: 3),
          bgColor: Colors.blue,
          textColor: Colors.black,
          iconColor: Colors.black,
        ).show(context);
      });
    }, (error) {
      print("One Time Payment Failed. Error: $error");
    }, () {
      print("One Time Payment Dismissed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Delivery Location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      color: Colors.teal,
                      child: Container(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.delLoc.latitude,
                                widget.delLoc.longitude),
                            zoom: 10,
                          ),
                          onMapCreated: _onMapCreated,
                          compassEnabled: true,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: markers.values.toSet(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                      child: Text(
                        "Customer Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "    Name: ",
                          ),
                          Text(
                            "$fname $lname",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 3, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "    Phone: ",
                          ),
                          Text(
                            "$phoneNo",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                      child: Text(
                        "Order Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.4,
                      child: ListView(
                        children:
                            List.generate(Cart.basketItems.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${Cart.basketItems[index].name} [${Cart.basketItems[index].price} x ${Cart.basketItems[index].quantity}]"),
                                Text(
                                    "   =  ${Cart.basketItems[index].quantity * Cart.basketItems[index].price}"),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Total: ${Cart.totalPrice.toString()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => OrderCompleted(
                          //           widget.delLoc,
                          //           Cart.totalPrice,
                          //           fname,
                          //           phoneNo)),
                          // );

                          openCheckout();
                        },
                        child: Text("Confirm & Pay"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(widget.delLoc.latitude, widget.delLoc.longitude),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
}
