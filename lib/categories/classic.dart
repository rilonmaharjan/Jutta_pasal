import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../order.dart';
import '../tiles/product_tile.dart';

class Classic extends StatefulWidget {
  const Classic({Key? key}) : super(key: key);

  @override
  State<Classic> createState() => _ClassicState();
}

class _ClassicState extends State<Classic> {
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
                      ((index) => "Classic" ==
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
                                      brandStore: firestoreitems[index]
                                          ['brand_store'],
                                      category: firestoreitems[index]
                                          ['category'],
                                      offer: firestoreitems[index]['offer'],
                                      productId: firestoreitems[index]
                                          ['productID'],
                                      type: firestoreitems[index]['type'],
                                    ));
                              },
                            )
                          : const SizedBox())));
            }
          }),
    );
  }
}
