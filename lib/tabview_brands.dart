// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:captcha/search_brands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'brand_products.dart';
import 'tiles/brandview_tile.dart';

class TabViewBrands extends StatefulWidget {
  const TabViewBrands({Key? key}) : super(key: key);

  @override
  State<TabViewBrands> createState() => _TabViewBrandsState();
}

class _TabViewBrandsState extends State<TabViewBrands> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchBrands())),
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
                  .collection("brand")
                  .orderBy("brand_name", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    'Loading...',
                  );
                } else {
                  List<QueryDocumentSnapshot<Object?>> firestoreitems =
                      snapshot.data!.docs;
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: firestoreitems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BrandViewTile(
                          image: firestoreitems[index]['image'],
                          logo: firestoreitems[index]['logo'],
                          onTap: () {
                            Get.to(() => BrandProducts(
                                  title: firestoreitems[index]['brand_name']
                                      .toString(),
                                  logo: firestoreitems[index]['logo'],
                                  image: firestoreitems[index]['image'],
                                ));
                          },
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
