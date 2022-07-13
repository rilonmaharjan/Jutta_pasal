// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Order extends StatefulWidget {
  final url;
  final String title;
  final price;
  final discount;
  final description;

  const Order({
    Key? key,
    required this.url,
    required this.price,
    required this.title,
    required this.discount,
    required this.description,
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            SizedBox(
              width: 5,
            ),
            Text(
              "Order",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 11),
            child: IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 0),
                          imageUrl: widget.url,
                          height: 200,
                          width: MediaQuery.of(context).size.width - 60,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Rs.",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      total.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  indent: 1,
                  endIndent: 1,
                  thickness: 0.5,
                  color: Color.fromARGB(255, 201, 198, 198),
                ),
                Row(
                  children: [
                    const Text(
                      "Quantity",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: decrease,
                      child: const Text("-"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(30, 30),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          primary: const Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.black),
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
                          primary: const Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  indent: 1,
                  endIndent: 1,
                  thickness: 0.5,
                  color: Color.fromARGB(255, 201, 198, 198),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: const [
                    Text(
                      "Deliver To",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    width: MediaQuery.of(context).size.width - 60,
                    height: 70,
                    margin: const EdgeInsets.only(top: 15, bottom: 25),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(
                          top: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 210, 210)),
                          left: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 210, 210)),
                          right: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 210, 210)),
                          bottom: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 210, 210)),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: locationMessage == ''
                                  ? const Center(
                                      child: CircularProgressIndicator())
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
                const Text(
                  "Receipt",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      style: TextStyle(color: Colors.grey, fontSize: 11),
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
                            style: TextStyle(fontWeight: FontWeight.w400),
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
                    Text(
                      "Rs. ${(100 + total) - (100 + total) * ((discountPercent) / 100)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart,
                            size: 18,
                            color: Color.fromARGB(255, 99, 98, 98),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 99, 98, 98)),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          primary: const Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.black),
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
                            color: Color.fromARGB(255, 99, 98, 98),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Buy Now",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 99, 98, 98)),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          primary: const Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
