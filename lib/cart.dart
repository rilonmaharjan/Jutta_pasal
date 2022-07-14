import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order.dart';
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
        title: Row(
          children: const [
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
        // actions: [
        //   GestureDetector(
        //     onTap:  () => deleteAllFromCart(context),
        //     child: Container(
        //       margin: const EdgeInsets.only(right: 20),
        //       child: const Icon(
        //         Icons.delete_outline_outlined,
        //         size: 24,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                              price: firestoreitems[index]['price'].toString(),
                              discount:
                                  firestoreitems[index]['discount'].toString(),
                              productID: firestoreitems[index]['productID'],
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
                            ))));
              }
            }),
      )),
    );
  }

  // Future deleteAllFromCart(context) async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //             child: CircularProgressIndicator(),
  //           ));

  //   FirebaseFirestore.instance
  //       .collection('cart')
  //       .doc(user!.email)
  //       .delete()
  //       .then(((value) => Get.back()))
  //       .then((value) => Get.snackbar('Deleted', 'Successfully Deleted',
  //           duration: const Duration(milliseconds: 2000),
  //           backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)));
  // }
}
