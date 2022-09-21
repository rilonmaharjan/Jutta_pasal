import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order.dart';
import 'tiles/product_tile.dart';

class BrandProducts extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title, image, logo, website, brandId;
  const BrandProducts(
      {Key? key, this.title, this.image, this.logo, this.website, this.brandId})
      : super(key: key);

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  final nameHolder = TextEditingController();
  
    User? user = FirebaseAuth.instance.currentUser;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                    imageUrl: widget.image,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(88, 185, 185, 185)),
                    child: Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: widget.logo,
                          height: 110,
                          width: 110,
                        )),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("brand")
                          .doc(widget.title)
                          .collection('followers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: SizedBox(),
                          );
                        } else {
                          List<QueryDocumentSnapshot<Object?>> firestoreitems =
                              snapshot.data!.docs;
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, left: 10),
                              padding: const EdgeInsets.all(3),
                              width: 80,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 253, 228, 213),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Row(
                                children: [
                                  const Text(
                                    'Followers:  ',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 8, 8, 8),
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    firestoreitems.length.toString(),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 8, 8, 8),
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("brand")
                          .doc(widget.title)
                          .collection('followers')
                          .where('followers name', isEqualTo: user!.email)
                          .snapshots(), builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(),
                      );
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreitems =
                          snapshot.data!.docs;
                      return Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, right: 10),
                          child: ElevatedButton(
                            onPressed:  firestoreitems.isNotEmpty ? unfollow : follow,
                            child: Text(
                              firestoreitems.isNotEmpty ? 'Unfollow' : 'Follow',
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 236, 236, 236)),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fixedSize: const Size(100, 30),
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                                primary: const Color.fromARGB(255, 26, 26, 26),
                                onPrimary:
                                    const Color.fromARGB(255, 53, 53, 53)),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10),
                child: Row(
                  children: [
                    const Text(
                      "Products",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        String url = widget.website.toString();
                        launchUrl(Uri.parse(url));
                      },
                      child: SizedBox(
                        child: Row(
                          children: const [
                            Text(
                              "Visit Us: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                            Icon(Icons.link)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
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
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Wrap(
                                children: List.generate(
                                    firestoreitems.length,
                                    ((index) => widget.title ==
                                            firestoreitems[index]['brand_store']
                                                .toString()
                                        ? ProductTile(
                                            image: firestoreitems[index]
                                                ['image'],
                                            title: firestoreitems[index]
                                                ['productName'],
                                            desc: firestoreitems[index]
                                                ['description'],
                                            price: firestoreitems[index]
                                                    ['price']
                                                .toString(),
                                            discount: firestoreitems[index]
                                                    ['discount']
                                                .toString(),
                                            onTap: () {
                                              Get.to(() => Order(
                                                    url: firestoreitems[index]
                                                        ['image'],
                                                    price: firestoreitems[index]
                                                            ['price']
                                                        .toString(),
                                                    title: firestoreitems[index]
                                                        ['productName'],
                                                    discount:
                                                        firestoreitems[index]
                                                                ['discount']
                                                            .toString(),
                                                    description:
                                                        firestoreitems[index]
                                                            ['description'],
                                                    brandStore:
                                                        firestoreitems[index]
                                                            ['brand_store'],
                                                    category:
                                                        firestoreitems[index]
                                                            ['category'],
                                                    offer: firestoreitems[index]
                                                        ['offer'],
                                                    productId:
                                                        firestoreitems[index]
                                                            ['productID'],
                                                    type: firestoreitems[index]
                                                        ['type'],
                                                  ));
                                            },
                                          )
                                        : const SizedBox())));
                          });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future follow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
       DocumentReference documentReferencer2 = FirebaseFirestore.instance
            .collection('brand')
            .doc(widget.title)
            .collection('followers')
            .doc(user!.email);
        Map<String, dynamic> data2 = <String, dynamic>{
          'followers name': user!.email,
        };

        await documentReferencer2.set(data2);

        DocumentReference documentReferencer = FirebaseFirestore.instance
            .collection('follow')
            .doc(user!.email)
            .collection('brands')
            .doc(widget.brandId);
        Map<String, dynamic> data = <String, dynamic>{
          'brand_name': widget.title,
          'image': widget.image,
          'logo': widget.logo,
          'website': widget.website,
          'brandId': widget.brandId,
        };

        await documentReferencer
            .set(data)
            .then((value) => Navigator.pop(context))
            .then((value) => Get.snackbar("Followed", "Successfully followed",
                duration: const Duration(milliseconds: 2000),
                backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
      
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
    }
  }


  Future unfollow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
       
  FirebaseFirestore.instance
            .collection('brand')
            .doc(widget.title)
            .collection('followers')
            .doc(user!.email)
            .delete();

        FirebaseFirestore.instance
            .collection('follow')
            .doc(user!.email)
            .collection('brands')
            .doc(widget.brandId)
            .delete()
            .then((value) => Navigator.pop(context))
            .then((value) => Get.snackbar(
                'Unfollowed', 'Successfully Unfollowed',
                duration: const Duration(milliseconds: 1500),
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)));
      
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
    }
  }

}
