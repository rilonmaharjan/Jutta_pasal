import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin_view/admin_upload_page.dart';
import 'admin_edit_page.dart';
import 'tiles/product_tile.dart';

class AdminViewPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables

  const AdminViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminViewPage> createState() => _AdminViewPageState();
}

class _AdminViewPageState extends State<AdminViewPage> {
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
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                              ((index) => ProductTile(
                                    image: firestoreitems[index]['image'],
                                    title: firestoreitems[index]['productName'],
                                    desc: firestoreitems[index]['description'],
                                    price: firestoreitems[index]['price']
                                        .toString(),
                                    discount: firestoreitems[index]['discount'],
                                    onTap: () {
                                      Get.to(AdminEditPage(
                                        productID: firestoreitems[index]
                                            ['productID'],
                                        brandEditName: firestoreitems[index]
                                                ['brand_store']
                                            .toString(),
                                        category: firestoreitems[index]
                                            ['category'],
                                        title: firestoreitems[index]
                                            ['productName'],
                                        desc: firestoreitems[index]
                                            ['description'],
                                        price: firestoreitems[index]['price']
                                            .toString(),
                                        discount: firestoreitems[index]
                                            ['discount'],
                                        offer: firestoreitems[index]['offer'],
                                        type: firestoreitems[index]['type'],
                                        color: firestoreitems[index]['color'],
                                      ));
                                    },
                                  ))));
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 40),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 1, 1, 1),
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Get.to(const AdminUploadPage(
                        brandUploadName: "",
                      ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
