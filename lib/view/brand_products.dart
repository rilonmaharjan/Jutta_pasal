import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order.dart';
import '../tiles/product_tile.dart';

class BrandProducts extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  const BrandProducts({Key? key, this.title}) : super(key: key);

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          widget.title + " Shoes",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
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
                          ((index) => widget.title ==
                                  firestoreitems[index]['brand_store']
                                      .toString()
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
