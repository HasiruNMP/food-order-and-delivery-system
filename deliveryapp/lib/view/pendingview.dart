import 'dart:convert';

import 'package:deliveryapp/model/order.dart';
import 'package:deliveryapp/view/deliverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({Key? key}) : super(key: key);

  @override
  _PendingOrdersViewState createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  var pendingorders = [];
  bool loaded = false;
  Future fetchpendingorders() async {
    String url = "https://10.0.2.2:7072/orders/getorderlist?EmployeeId=1";

    final response = await http.get(Uri.parse(url));
    var resJson = json.decode(response.body);

    if (response.statusCode == 200) {
      var a = resJson as List;
      pendingorders = a.toList();
      setState(() => loaded = true);
    }
    else {
      print(response.reasonPhrase);
    }
  }
  @override
  void initState() {
    fetchpendingorders();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: SafeArea(
        child: (loaded)?
        Container(
          child: (pendingorders.length != 0)?
          ListView(
              children: List.generate(pendingorders.length, (index) {
                return Card(
                  child: ListTile(
                    title: pendingorders[index]['OrderId'],
                    subtitle: pendingorders[index]['datetime'],
                  ),

                );
              })
          ):
          Center(child: Text("No Results"),),
        ):
        Center(child: Text("Press Search"),),
      ),
    );
  }
}