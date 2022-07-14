import 'package:captcha/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tiles/product_tile.dart';

class SearchProducts extends StatefulWidget {
  const SearchProducts({Key? key}) : super(key: key);

  @override
  State<SearchProducts> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 46, 46, 46),
                  size: 21,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<QueryDocumentSnapshot<Object?>> firestoreitems =
                      snapshot.data!.docs;
                  return Wrap(
                      children: List.generate(
                          firestoreitems.length,
                          ((index) => ProductTile(
                                image: firestoreitems[index]['image'],
                                title: firestoreitems[index]['productName'],
                                desc: firestoreitems[index]['description'],
                                price:
                                    firestoreitems[index]['price'].toString(),
                                discount: firestoreitems[index]['discount'],
                                onTap: () {
                                  Get.to(Order(
                                    title: firestoreitems[index]['productName'],
                                    price: firestoreitems[index]['price']
                                        .toString(),
                                    discount: firestoreitems[index]['discount'],
                                    description: firestoreitems[index]
                                        ['description'],
                                    url: firestoreitems[index]['image'],
                                    brandStore: firestoreitems[index]
                                        ['brand_store'],
                                    category: firestoreitems[index]['category'],
                                    offer: firestoreitems[index]['offer'],
                                    productId: firestoreitems[index]
                                        ['productID'],
                                    type: firestoreitems[index]['type'],
                                  ));
                                },
                              ))));
                }
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
