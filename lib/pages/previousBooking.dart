import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rcapp/models/user.dart';

class PreviousBooking extends StatefulWidget {
  @override
  _PreviousBookingState createState() => _PreviousBookingState();
}

class _PreviousBookingState extends State<PreviousBooking> {
  List<dynamic> bookings = [];

  String name = '';
  String number = '';
  String lounge = '';
  int slot;
  int documentlength = 1;

  void initialData() async {
    var uid = (await FirebaseAuth.instance.currentUser()).uid;
    var result = await Firestore.instance
        .collection('BookingDetails')
        .where('id', isEqualTo: uid)
        .getDocuments();
    setState(() {
      documentlength = result.documents.length;
    });
    result.documents.forEach((res) {
      setState(() {
        bookings.add(res.data);
        name = res.data["name"];
        number = res.data["number"];
        lounge = res.data["lounge"];
        slot = res.data["slot"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    int orderNo = 110;
    if (bookings.length == 0 && documentlength == 1) {
      return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SpinKitCircle(color: Colors.deepOrange, size: 65),
              Text('Loading data')
            ])),
      );
    } else if (documentlength == 0) {
      return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Icon(Icons.all_inclusive),
              Text('No data')
            ])),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Booking'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bookings.length,
            itemBuilder: (_, index) {
              orderNo = 110;
              orderNo += index;
              return ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 220.0,
                      width: 370.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "#$orderNo",
                                style: TextStyle(
                                    color: Colors.deepOrange, fontSize: 22),
                              ),
                              Flexible(
                                  child: Text('${bookings[index]["date"]}')),
                            ],
                          ),
                          SizedBox(height: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Name : " + "${bookings[index]["name"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Personal No. : " +
                                          "${bookings[index]["number"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Lounge : " +
                                          "${bookings[index]["lounge"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Slot: ${bookings[index]["slot"]}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                   
                                  ],
                                ),
                              ]),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
