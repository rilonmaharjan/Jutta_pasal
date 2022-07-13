import 'package:captcha/offer.dart';
import 'package:captcha/tiles/brand_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../brand_products.dart';
import '../order.dart';
import '../tiles/offer_tile.dart';
import '../tiles/product_tile.dart';
import '../brand.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 8, right: 8, bottom: 5),
                    child: Row(
                      children: [
                        const Text(
                          "Offer",
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Offer());
                          },
                          child: const Text(
                            "View More",
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return OfferTile(
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
                                    title: firestoreitems[index]['productName'],
                                    discount: firestoreitems[index]['discount']
                                        .toString(),
                                    description: firestoreitems[index]
                                        ['description'],
                                  ));
                            },
                          );
                        }),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("brand")
                          .orderBy("brand_name", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<QueryDocumentSnapshot<Object?>> firestoreitems =
                              snapshot.data!.docs;

                          return Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 4, right: 4, bottom: 15),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Our Brand Partners",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => const Brand());
                                        },
                                        child: const Text(
                                          "View More",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return BrandTile(
                                          logo: firestoreitems[index]['logo'],
                                          brandName: firestoreitems[index]
                                              ['brand_name'],
                                          onTap: () {
                                            Get.to(() => BrandProducts(
                                                  title: firestoreitems[index]
                                                          ['brand_name']
                                                      .toString(),
                                                ));
                                          },
                                        );
                                      }),
                                )
                              ],
                            ),
                          );
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 8, right: 8, bottom: 5),
                    child: Row(
                      children: const [
                        Text(
                          "Our Products",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
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
                      }),
                ],
              );
            }
          }),
    );
  }
}
