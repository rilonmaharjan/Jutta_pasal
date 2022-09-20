import 'package:captcha/refresh.dart';
import 'package:captcha/tiles/order_request_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({ Key? key }) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
   final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black, size: 25),
          actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          elevation: 0.5,
          title: const Text(
            "Order History",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Refresher(
            refreshbody: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("order request")
                        .doc(user?.email)
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreitems =
                            snapshot.data!.docs;
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: firestoreitems.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return OrderRequestTile(logo: firestoreitems[index]['image'],
                              productName: firestoreitems[index]['productName'],
                              productId: firestoreitems[index]['productID'],);
                            });
                      }
                    }),
              ),
            ),
            refreshitem: const SpinKitHourGlass(
              duration: Duration(milliseconds: 1000),
              color: Color.fromARGB(255, 199, 228, 255),
              size: 25.0,
            ),
          ),
        ));
  }
}