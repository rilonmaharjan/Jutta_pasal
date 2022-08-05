import 'package:captcha/tiles/followed_store_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'brand_products.dart';
import 'refresh.dart';

class FollowedBrandViewPage extends StatefulWidget {
  const FollowedBrandViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FollowedBrandViewPage> createState() => _FollowedBrandViewPageState();
}

class _FollowedBrandViewPageState extends State<FollowedBrandViewPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black, size: 25),
          actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          elevation: 0.5,
          title: const Text(
            "Followed Stores",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Refresher(
            refreshbody: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("follow")
                        .doc(user?.email)
                        .collection('brands')
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
                            itemCount: firestoreitems.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return FollowedStoreTile(
                                  logo: firestoreitems[index]['logo'],
                                  brandName: firestoreitems[index]
                                      ['brand_name'],
                                  website: firestoreitems[index]['website'],
                                  brandId: firestoreitems[index]['brandId'],
                                  ontap: () {
                                    Get.to(() => BrandProducts(
                                          title: firestoreitems[index]
                                                  ['brand_name']
                                              .toString(),
                                          logo: firestoreitems[index]['logo'],
                                          image: firestoreitems[index]['image'],
                                          website: firestoreitems[index]
                                              ['website'],
                                          brandId: firestoreitems[index]
                                              ['brandId'],
                                        ));
                                  });
                            });
                      }
                    }),
              ),
            ),
            refreshitem: const SpinKitHourGlass(
              duration: Duration(milliseconds: 1000),
              color: Color.fromARGB(255, 199, 228, 255),
              size: 25.0,
            ),
          ),
        ));
  }
}
