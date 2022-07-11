import 'package:captcha/admin_edit_page.dart';
import 'package:captcha/tiles/product_tile..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_upload_page.dart';

class AdminViewPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables

  const AdminViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminViewPage> createState() => _AdminViewPageState();
}

class _AdminViewPageState extends State<AdminViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
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
