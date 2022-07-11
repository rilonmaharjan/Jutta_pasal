import 'package:captcha/order.dart';
import 'package:captcha/tiles/product_tile..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_edit_page.dart';
import 'admin_view_page.dart';
import 'super_admin_user_view_page.dart';
import 'vendor_admin_view_page.dart';

class Jutta extends StatefulWidget {
  const Jutta({Key? key}) : super(key: key);

  @override
  State<Jutta> createState() => _KhanaState();
}

class _KhanaState extends State<Jutta> {
  borderdec() {
    return const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(17)),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 185, 184, 184),
              offset: Offset(5, 5),
              blurRadius: 10)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
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
                                    discount: firestoreitems[index]['discount']
                                        .toString(),
                                    onTap: () {
                                      Get.to(() => Order(
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
                                          ));
                                    },
                                  ))));
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        elevation: 0.0,
                        child: const Icon(Icons.logout)),
                    const SizedBox(
                      height: 15,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where('email', isEqualTo: user!.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            List<QueryDocumentSnapshot<Object?>>
                                firestoreUsers = snapshot.data!.docs;
                            return firestoreUsers[0]['role'] == 'vendorAdmin'
                                ? FloatingActionButton(
                                    onPressed: () {
                                      Get.to(() => VendorAdminViewPage(
                                            adminRole: firestoreUsers[0]
                                                    ['adminrole']
                                                .toString(),
                                          ));
                                    },
                                    elevation: 0.0,
                                    child:
                                        const Icon(Icons.admin_panel_settings),
                                  )
                                : firestoreUsers[0]['role'] == 'superAdmin'
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FloatingActionButton(
                                            onPressed: () {
                                              Get.to(
                                                  const SuperAdminUserViewPage());
                                            },
                                            elevation: 0.0,
                                            child: const Icon(Icons.person),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              Get.to(
                                                  () => const AdminViewPage());
                                            },
                                            elevation: 0.0,
                                            child: const Icon(Icons.edit),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(
                                        height: 10,
                                      );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
