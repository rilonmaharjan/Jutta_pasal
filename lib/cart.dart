import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'order.dart';
import 'refresh.dart';
import 'tiles/cart_tile.dart';

class Cart extends StatefulWidget {
  const Cart({
    Key? key,
  }) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black, size: 25),
          actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Text(
                "My Basket",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Refresher(
            refreshbody: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("cart")
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
                      return Wrap(
                          children: List.generate(
                              firestoreitems.length,
                              ((index) => CartTile(
                                    image: firestoreitems[index]['image'],
                                    title: firestoreitems[index]['productName'],
                                    desc: firestoreitems[index]['description'],
                                    price: firestoreitems[index]['price']
                                        .toString(),
                                    discount: firestoreitems[index]['discount']
                                        .toString(),
                                    productID: firestoreitems[index]
                                        ['productID'],
                                    onTap: () {
                                      Get.to(() => OrderPage(
                                            url: firestoreitems[index]['image'],
                                            price: firestoreitems[index]
                                                    ['price']
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
                                            offer: firestoreitems[index]
                                                ['offer'],
                                            productId: firestoreitems[index]
                                                ['productID'],
                                            type: firestoreitems[index]['type'],
                                          ));
                                    },
                                  ))));
                    }
                  }),
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
