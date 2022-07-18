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
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
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
                  hintText: 'Search for Brands..',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: (name != "")
                    ? FirebaseFirestore.instance
                        .collection('brand')
                        .where('brand_name', isGreaterThanOrEqualTo: name)
                        .where('brand_name', isLessThan: name + 'z')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("brand")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(
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
                            logo: firestoreitems[index]['logo'],
                            onTap: () {
                              Get.to(() => BrandProducts(
                                    title: firestoreitems[index]['brand_name']
                                        .toString(),
                                  ));
                            },
                          );
                        });
                  }
                  return const SizedBox();
                }),
          ),
        ),
      ),
    );
  }
}
