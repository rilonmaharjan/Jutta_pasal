import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'list/color_list.dart';
import 'order.dart';
import 'tiles/color_tile.dart';
import 'tiles/product_tile.dart';

class ColorView extends StatefulWidget {
  const ColorView({Key? key}) : super(key: key);

  @override
  State<ColorView> createState() => _ColorViewState();
}

class _ColorViewState extends State<ColorView> {
  final shoescolor = "Black".obs;
  int changeSize = 0;
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
              "Pick Your Favourite Color",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("banner")
                    .orderBy("image", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreBannerImage =
                        snapshot.data!.docs;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 4.3,
                      child: CarouselSlider.builder(
                          unlimitedMode: true,
                          itemCount: firestoreBannerImage.length,
                          enableAutoSlider: true,
                          autoSliderDelay: const Duration(seconds: 3),
                          autoSliderTransitionTime:
                              const Duration(milliseconds: 500),
                          slideIndicator: CircularSlideIndicator(
                              itemSpacing: 15.0,
                              indicatorBackgroundColor:
                                  const Color.fromARGB(66, 22, 22, 22),
                              currentIndicatorColor: Colors.white,
                              padding: const EdgeInsets.only(bottom: 10)),
                          slideBuilder: (index) {
                            return CachedNetworkImage(
                              imageUrl: firestoreBannerImage[index]["image"],
                              fit: BoxFit.cover,
                            );
                          }),
                    );
                  }
                })),
            const Padding(
              padding: EdgeInsets.only(top: 25, bottom: 5, left: 15),
              child: Text(
                "COLOUR CHOICES",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Obx(
              () => StickyHeader(
                header: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  color: const Color.fromARGB(255, 250, 250, 250),
                  width: MediaQuery.of(context).size.width,
                  height: 82,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ColorTile(
                          onTap: () {
                            shoescolor.value = colors[index]["text"].toString();
                            changeSize = index;
                          },
                          color: colors[index]['color'],
                          text: colors[index]['text'],
                          bgcolor:
                              changeSize == index ? '0xffccdde7' : '0xfffafafa',
                        );
                      }),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        shoescolor.value.toUpperCase(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: shoescolor.value == "Black" ||
                              shoescolor.value == "Red" ||
                              shoescolor.value == "Blue" ||
                              shoescolor.value == "White" ||
                              shoescolor.value == "Yellow"
                          ? FirebaseFirestore.instance
                              .collection('products')
                              .where("color", isEqualTo: shoescolor.value)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('products')
                              .where("color", isEqualTo: shoescolor.value)
                              .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height -
                                kToolbarHeight,
                            child: const Center(
                              child: Text("loading..."),
                            ),
                          );
                        } else {
                          List<QueryDocumentSnapshot<Object?>> firestoreitems =
                              snapshot.data!.docs;
                          return Column(
                            children: [
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Wrap(
                                        alignment: WrapAlignment.start,
                                        children: List.generate(
                                            firestoreitems.length,
                                            ((index) => ProductTile(
                                                  image: firestoreitems[index]
                                                      ['image'],
                                                  title: firestoreitems[index]
                                                      ['productName'],
                                                  desc: firestoreitems[index]
                                                      ['description'],
                                                  price: firestoreitems[index]
                                                          ['price']
                                                      .toString(),
                                                  discount:
                                                      firestoreitems[index]
                                                              ['discount']
                                                          .toString(),
                                                  onTap: () {
                                                    Get.to(() => Order(
                                                          url: firestoreitems[
                                                              index]['image'],
                                                          price: firestoreitems[
                                                                      index]
                                                                  ['price']
                                                              .toString(),
                                                          title: firestoreitems[
                                                                  index]
                                                              ['productName'],
                                                          discount:
                                                              firestoreitems[
                                                                          index]
                                                                      [
                                                                      'discount']
                                                                  .toString(),
                                                          description:
                                                              firestoreitems[
                                                                      index][
                                                                  'description'],
                                                          brandStore:
                                                              firestoreitems[
                                                                      index][
                                                                  'brand_store'],
                                                          category:
                                                              firestoreitems[
                                                                      index]
                                                                  ['category'],
                                                          offer: firestoreitems[
                                                              index]['offer'],
                                                          productId:
                                                              firestoreitems[
                                                                      index]
                                                                  ['productID'],
                                                          type: firestoreitems[
                                                              index]['type'],
                                                        ));
                                                  },
                                                ))));
                                  }),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
