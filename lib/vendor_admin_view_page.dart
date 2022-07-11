import 'package:captcha/admin_edit_page.dart';
import 'package:captcha/tiles/product_tile..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_upload_page.dart';

class VendorAdminViewPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final adminRole;
  const VendorAdminViewPage({Key? key, this.adminRole}) : super(key: key);

  @override
  State<VendorAdminViewPage> createState() => _VendorAdminViewPageState();
}

class _VendorAdminViewPageState extends State<VendorAdminViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
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
                                ((index) => widget.adminRole ==
                                        firestoreitems[index]['brand_store']
                                            .toString()
                                    ? ProductTile(
                                        image: firestoreitems[index]['image'],
                                        title: firestoreitems[index]
                                            ['productName'],
                                        desc: firestoreitems[index]
                                            ['description'],
                                        price: firestoreitems[index]['price']
                                            .toString(),
                                        discount: firestoreitems[index]
                                            ['discount'],
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
                                            price: firestoreitems[index]
                                                    ['price']
                                                .toString(),
                                            discount: firestoreitems[index]
                                                ['discount'],
                                          ));
                                        },
                                      )
                                    : const SizedBox())));
                      }
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 40),
                  child: Align(
                      alignment: Alignment.bottomRight,
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
                            List<QueryDocumentSnapshot<Object?>>
                                firestoreitems = snapshot.data!.docs;
                            return FloatingActionButton(
                                child: const Icon(Icons.add),
                                onPressed: () {
                                  Get.to(AdminUploadPage(
                                      brandUploadName: firestoreitems[0]
                                              ['brand_store']
                                          .toString()));
                                });
                          }
                        },
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
