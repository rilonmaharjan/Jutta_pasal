import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order.dart';
import 'tiles/product_tile.dart';

class BrandProducts extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title, image, logo;
  const BrandProducts({Key? key, this.title, this.image, this.logo})
      : super(key: key);

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              controller: nameHolder,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 46, 46, 46),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromARGB(185, 44, 44, 44),
                    ),
                    onPressed: clearTextInput,
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                    imageUrl: widget.image,
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 182,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(88, 185, 185, 185)),
                    child: Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: widget.logo,
                          height: 110,
                          width: 110,
                        )),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10),
                child: Text(
                  "Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: (name != "")
                      ? FirebaseFirestore.instance
                          .collection('products')
                          .where('productName', isGreaterThanOrEqualTo: name)
                          .where('productName', isLessThan: name + 'z')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                                    ((index) => widget.title ==
                                            firestoreitems[index]['brand_store']
                                                .toString()
                                        ? ProductTile(
                                            image: firestoreitems[index]
                                                ['image'],
                                            title: firestoreitems[index]
                                                ['productName'],
                                            desc: firestoreitems[index]
                                                ['description'],
                                            price: firestoreitems[index]
                                                    ['price']
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
                                                    discount:
                                                        firestoreitems[index]
                                                                ['discount']
                                                            .toString(),
                                                    description:
                                                        firestoreitems[index]
                                                            ['description'],
                                                    brandStore:
                                                        firestoreitems[index]
                                                            ['brand_store'],
                                                    category:
                                                        firestoreitems[index]
                                                            ['category'],
                                                    offer: firestoreitems[index]
                                                        ['offer'],
                                                    productId:
                                                        firestoreitems[index]
                                                            ['productID'],
                                                    type: firestoreitems[index]
                                                        ['type'],
                                                  ));
                                            },
                                          )
                                        : const SizedBox())));
                          });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
