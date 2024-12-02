import 'package:captcha/offer.dart';
import 'package:captcha/tiles/brand_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
              return const SizedBox();
            } else {
              List<QueryDocumentSnapshot<Object?>> firestoreitems =
                  snapshot.data!.docs;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 8, right: 8, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Offer",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Ends In : ",
                              style: TextStyle(fontSize: 13),
                            ),
                            CountDownText(
                              due: DateTime.parse("2027-10-20 00:00:00"),
                              finishedText: "Ended",
                              showLabel: true,
                              longDateName: false,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
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
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 16,
                          itemBuilder: (context, index) {
                            return "Yes" ==
                                    firestoreitems[index]['offer'].toString()
                                ? OfferTile(
                                    image: firestoreitems[index]['image'],
                                    title: firestoreitems[index]['productName'],
                                    desc: firestoreitems[index]['description'],
                                    price: firestoreitems[index]['price']
                                        .toString(),
                                    discount: firestoreitems[index]['discount']
                                        .toString(),
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
                                  )
                                : const SizedBox();
                          }),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("brand")
                          .orderBy("brand_name", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
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
                                        "Our Stores",
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
                                                  brandId: firestoreitems[index]
                                                      ['brandId'],
                                                  title: firestoreitems[index]
                                                          ['brand_name']
                                                      .toString(),
                                                  logo: firestoreitems[index]
                                                      ['logo'],
                                                  image: firestoreitems[index]
                                                      ['image'],
                                                  website: firestoreitems[index]
                                                      ['website'],
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
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 25.0, left: 8, right: 8, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          "Our Products",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
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
                                Get.to(() => OrderPage(
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
                                    brandStore: firestoreitems[index]
                                        ['brand_store'],
                                    category: firestoreitems[index]
                                        ['category'],
                                    offer: firestoreitems[index]
                                        ['offer'],
                                    productId: firestoreitems[index]
                                        ['productID'],
                                    type: firestoreitems[index]
                                        ['type'],
                                  )
                                );
                              },
                            )
                          )
                        )
                      ),
                  ), 
                ],
              );
            }
          }),
    );
  }
}
