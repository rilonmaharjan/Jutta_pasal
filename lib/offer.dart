import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order.dart';
import 'tiles/product_tile.dart';

class Offer extends StatefulWidget {
  const Offer({Key? key}) : super(key: key);

  @override
  State<Offer> createState() => _OfferState();
}

class _OfferState extends State<Offer> {
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
          width: MediaQuery.of(context).size.width * 0.9,
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
                  hintText: 'Search for Offers..',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
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
                          ((index) => "Yes" ==
                                  firestoreitems[index]['offer'].toString()
                              ? ProductTile(
                                  image: firestoreitems[index]['image'],
                                  title: firestoreitems[index]['productName'],
                                  desc: firestoreitems[index]['description'],
                                  price:
                                      firestoreitems[index]['price'].toString(),
                                  discount: firestoreitems[index]['discount']
                                      .toString(),
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
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
