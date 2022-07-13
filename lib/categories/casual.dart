import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../order.dart';
import '../tiles/product_tile.dart';

class Casual extends StatefulWidget {
  const Casual({Key? key}) : super(key: key);

  @override
  State<Casual> createState() => _CasualState();
}

class _CasualState extends State<Casual> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
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
                      ((index) => "Casual" ==
                              firestoreitems[index]['type'].toString()
                          ? ProductTile(
                              image: firestoreitems[index]['image'],
                              title: firestoreitems[index]['productName'],
                              desc: firestoreitems[index]['description'],
                              price: firestoreitems[index]['price'].toString(),
                              discount:
                                  firestoreitems[index]['discount'].toString(),
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
    );
  }
}
