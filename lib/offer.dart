import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order.dart';
import 'tiles/product_tile.dart';

class Offer extends StatefulWidget {
  const Offer({Key? key}) : super(key: key);

  @override
  State<Offer> createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: const [
            SizedBox(
              width: 8,
            ),
            Text(
              "Offer",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.local_offer,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<QueryDocumentSnapshot<Object?>> firestoreitems =
                      snapshot.data!.docs;
                  return Wrap(
                      children: List.generate(
                          firestoreitems.length,
                          ((index) => "Yes" ==
                                  firestoreitems[index]['offer'].toString()
                              ? ProductTile(
                                  image: firestoreitems[index]['image'],
                                  title: firestoreitems[index]['productName'],
                                  desc: firestoreitems[index]['description'],
                                  price:
                                      firestoreitems[index]['price'].toString(),
                                  discount: firestoreitems[index]['discount']
                                      .toString(),
                                  onTap: () {
                                    Get.to(() => Order(
                                          url: firestoreitems[index]['image'],
                                          price: firestoreitems[index]['price']
                                              .toString(),
                                          title: firestoreitems[index]
                                              ['productName'],
                                          discount: firestoreitems[index]
                                                  ['discount']
                                              .toString(),
                                          description: firestoreitems[index]
                                              ['description'],
                                        ));
                                  },
                                )
                              : const SizedBox())));
                }
              }),
        ),
      ),
    );
  }
}
