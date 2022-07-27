import 'package:captcha/categories/casual.dart';
import 'package:captcha/categories/classic.dart';
import 'package:captcha/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'super_admin_view_page.dart';
import 'categories/all.dart';
import 'categories/kids.dart';
import 'categories/men.dart';
import 'categories/sports.dart';
import 'categories/women.dart';
import 'list/category_list.dart';
import 'super_admin_user_view_page.dart';
import 'tiles/category_tile.dart';
import 'vendor_admin_view_page.dart';

class Jutta extends StatefulWidget {
  const Jutta({Key? key}) : super(key: key);

  @override
  State<Jutta> createState() => _KhanaState();
}

class _KhanaState extends State<Jutta> {
  var option = "All";
  int changeColorandSize = 0;

  swtichfunction() {
    switch (option) {
      case "All":
        return const All();
      case "Men":
        return const Men();
      case "Women":
        return const Women();
      case "Kids":
        return const Kids();
      case "Sports":
        return const Sports();
      case "Classic":
        return const Classic();
      case "Casual":
        return const Casual();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where('email', isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      'Loading...',
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreItems =
                        snapshot.data!.docs;
                    var fname = firestoreItems[0]['name'].split(" ");
                    return Text(
                      "HELLO,  " + fname[0].toString().toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                }),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SearchView());
                  },
                  child: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 24,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    String mailUrl =
                        "mailto:rilon.maharjan@gmail.com?subject=Message to JuttaPasal&body";
                    launchUrl(Uri.parse(mailUrl));
                  },
                  child: const Icon(
                    Icons.message,
                    color: Color.fromARGB(255, 65, 65, 65),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 58),
                width: MediaQuery.of(context).size.width,
                child: swtichfunction(),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: SizedBox(
                    width: size.width,
                    height: 35,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            categoryName: categoryList[index]['name'],
                            onTap: () {
                              setState(() {
                                option = categoryList[index]['name'].toString();
                                changeColorandSize = index;
                              });
                            },
                            color: changeColorandSize == index
                                ? "0xff010101"
                                : "0xffededed",
                            textColor: changeColorandSize == index
                                ? "0xffffffff"
                                : "0xff000000",
                            textSize: changeColorandSize == index ? 13.5 : 12.0,
                          );
                        }),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where('email', isEqualTo: user.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreUsers =
                            snapshot.data!.docs;
                        return firestoreUsers[0]['role'] == 'vendorAdmin'
                            ? FloatingActionButton(
                                backgroundColor:
                                    const Color.fromARGB(255, 1, 1, 1),
                                onPressed: () {
                                  Get.to(() => VendorAdminViewPage(
                                        adminRole: firestoreUsers[0]
                                                ['adminrole']
                                            .toString(),
                                      ));
                                },
                                elevation: 0.0,
                                child: const Icon(Icons.admin_panel_settings),
                              )
                            : firestoreUsers[0]['role'] == 'superAdmin'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FloatingActionButton(
                                        backgroundColor: const Color.fromARGB(
                                            255, 40, 40, 40),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 40, 40, 40),
                                        onPressed: () {
                                          Get.to(() => const AdminViewPage());
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
