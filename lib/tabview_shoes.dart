// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:captcha/search_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order.dart';
import 'tiles/product_tile.dart';

class TabViewShoes extends StatefulWidget {
  const TabViewShoes({Key? key}) : super(key: key);

  @override
  State<TabViewShoes> createState() => _TabViewShoesState();
}

class _TabViewShoesState extends State<TabViewShoes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchProducts())),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 15),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.search,
                          size: 28,
                          color: Color.fromARGB(255, 134, 134, 134),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Search...",
                          style: TextStyle(
                              color: Color.fromARGB(255, 134, 134, 134),
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Color.fromARGB(255, 134, 134, 134),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .orderBy("productName", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    'No User Data...',
                  );
                } else {
                  List<QueryDocumentSnapshot<Object?>> firestoreitems =
                      snapshot.data!.docs;
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Wrap(
                            children: List.generate(
                                firestoreitems.length,
                                ((index) => ProductTile(
                                      image: firestoreitems[index]['image'],
                                      title: firestoreitems[index]
                                          ['productName'],
                                      desc: firestoreitems[index]
                                          ['description'],
                                      price: firestoreitems[index]['price']
                                          .toString(),
                                      discount: firestoreitems[index]
                                              ['discount']
                                          .toString(),
                                      onTap: () {
                                        Get.to(() => Order(
                                              url: firestoreitems[index]
                                                  ['image'],
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
                                            ));
                                      },
                                    ))));
                      });
                }
              }),
        ],
      ),
    );
  }
}
