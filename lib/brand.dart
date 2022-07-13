import 'package:captcha/brand_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tiles/brandview_tile.dart';

class Brand extends StatefulWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Our Brand Partners",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("brand").snapshots(),
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: firestoreitems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BrandViewTile(
                            image: firestoreitems[index]['image'],
                            brandName: firestoreitems[index]['brand_name'],
                            onTap: () {
                              Get.to(() => BrandProducts(
                                    title: firestoreitems[index]['brand_name']
                                        .toString(),
                                  ));
                            },
                          );
                        });
                  }
                }),
          ),
        ),
      ),
    );
  }
}
