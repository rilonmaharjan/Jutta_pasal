// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTile extends StatefulWidget {
  final image, desc, title, price, discount, productID;
  final VoidCallback? onTap;
  const CartTile(
      {Key? key,
      this.image,
      this.title,
      this.price,
      this.discount,
      this.desc,
      required this.productID,
      this.onTap})
      : super(key: key);

  @override
  State<CartTile> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<CartTile> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2.125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.image,
                      width: MediaQuery.of(context).size.width / 2.125,
                      fit: BoxFit.cover,
                    ),
                    widget.discount.isEmpty
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 55,
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 36, 36, 36),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30))),
                              child: Text(
                                "- " + widget.discount + "  %",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => deletefromcart(context),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Icon(Icons.delete_outline),
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.desc,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          widget.discount.isEmpty
                              ? RichText(
                                  text: TextSpan(
                                      text: "Rs.",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 37, 37, 37)),
                                      children: [
                                      TextSpan(
                                        text: widget.price,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ]))
                              : RichText(
                                  text: TextSpan(
                                      text: "Rs.",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 37, 37, 37)),
                                      children: [
                                      TextSpan(
                                        text:
                                            "${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ])),
                          const SizedBox(
                            width: 10,
                          ),
                          widget.discount.isEmpty
                              ? const SizedBox()
                              : Text(
                                  "Rs." + widget.price,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 139, 139, 139),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future deletefromcart(context) async {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.email)
        .collection('products')
        .doc(widget.productID)
        .delete()
        .then(((value) => Get.back()))
        .then((value) => Get.snackbar('Deleted', 'Successfully Deleted',
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)));
  }
}
