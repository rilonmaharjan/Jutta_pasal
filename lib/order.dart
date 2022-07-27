// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:captcha/reviews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Order extends StatefulWidget {
  final url;
  final String title;
  final price;
  final discount;
  final description;
  final brandStore;
  final category;
  final offer;
  final productId;
  final type;

  const Order({
    Key? key,
    required this.url,
    required this.price,
    required this.title,
    required this.discount,
    required this.description,
    required this.brandStore,
    required this.category,
    required this.offer,
    required this.productId,
    required this.type,
  }) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  int quantity = 1;
  var total;
  var locationMessage = "";
  var address = "";
  var total1;
  var discountPercent;

  final user = FirebaseAuth.instance.currentUser;

  increase() {
    setState(() {
      if (quantity >= 20) {
        quantity;
      } else {
        quantity++;
        //total = total + widget.desc;
        total = total + int.parse(widget.price);
      }
    });
  }

  decrease() {
    setState(() {
      if (quantity <= 1) {
        quantity;
      } else {
        --quantity;
        //total = total - widget.desc;
        total = total - int.parse(widget.price);
      }
    });
  }

  Future getAddressFromLatLong() async {
    await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      locationMessage = address;
    });
  }

  @override
  void initState() {
    widget.discount.isEmpty
        ? discountPercent = 0
        : discountPercent = double.parse(widget.discount);
    total = int.parse(widget.price);
    getAddressFromLatLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: InteractiveViewer(
                            child: AlertDialog(
                                titlePadding: const EdgeInsets.all(0),
                                title: CachedNetworkImage(
                                  fadeInDuration:
                                      const Duration(milliseconds: 0),
                                  imageUrl: widget.url,
                                  // height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 0),
                      imageUrl: widget.url,
                      height: 310,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        top: 21, bottom: 18, left: 20, right: 20),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 10)
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => Reviews(
                                      productID: widget.productId,
                                    ));
                              },
                              child: SizedBox(
                                child: Row(
                                  children: const [
                                    Text(
                                      "See Reviews",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.teal),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.brandStore.toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Rs. ",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: widget.price,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 51, 51, 51),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        top: 21, bottom: 18, left: 20, right: 20),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 10)
                    ]),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Deliver To",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: Color.fromARGB(176, 244, 67, 54),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Edit Location",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(176, 244, 67, 54),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 2,
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: getAddressFromLatLong,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 20, bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: const Border(
                                  top: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 211, 210, 210)),
                                  left: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 211, 210, 210)),
                                  right: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 211, 210, 210)),
                                  bottom: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 211, 210, 210)),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          "Current Location",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 110, 110, 110),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: locationMessage == ''
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Text(
                                              locationMessage,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        top: 21, bottom: 18, left: 20, right: 20),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 10)
                    ]),
                    child: Row(
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: decrease,
                          child: const Text(
                            "-",
                          ),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(30, 30),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              primary: const Color.fromARGB(226, 0, 0, 0),
                              onPrimary:
                                  const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: increase,
                          child: const Text("+"),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(30, 30),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              primary: const Color.fromARGB(226, 0, 0, 0),
                              onPrimary:
                                  const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        top: 21, bottom: 18, left: 20, right: 20),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 10)
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Receipt",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Sub Total",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "(With VAT):",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text("Rs."),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(total.toString()),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Deliver Fee:",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Text("Rs. 100"),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.discount.isEmpty
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(
                                    "Discount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                  const Spacer(),
                                  Text(widget.discount + " %"),
                                ],
                              ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(
                          indent: 0,
                          endIndent: 0,
                          thickness: 1,
                          color: Color.fromARGB(255, 201, 198, 198),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            const Text(
                              "Rs.",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "${((total) - (total) * ((discountPercent) / 100)) + 100}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, top: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 22,
                        )),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: addtocart,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart,
                            size: 18,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Add to Cart",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 238, 238, 238),
                              )),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          onPrimary: const Color.fromARGB(255, 184, 183, 183),
                          primary: Colors.black),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shop,
                            size: 18,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Buy Now",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 238, 238, 238),
                              )),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          onPrimary: const Color.fromARGB(255, 184, 183, 183),
                          primary: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future addtocart() async {
    User? user = FirebaseAuth.instance.currentUser;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.email)
          .collection('products')
          .doc(widget.productId);
      Map<String, dynamic> data = <String, dynamic>{
        'brand_store': widget.brandStore,
        'productName': widget.title,
        'description': widget.description,
        'price': widget.price,
        'discount': widget.discount,
        'image': widget.url,
        'productID': widget.productId,
        'category': widget.category,
        'offer': widget.offer,
        'type': widget.type,
      };

      await documentReferencer
          .set(data)
          .then((value) => Navigator.pop(context))
          .then((value) => Get.snackbar("Added", "Item added to cart",
              duration: const Duration(milliseconds: 2000),
              backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
    }
  }
}
