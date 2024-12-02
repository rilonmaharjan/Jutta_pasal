// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRequestTile extends StatefulWidget {
  final productName, logo, productId;
  const OrderRequestTile({Key? key, this.productName, this.logo, this.productId}) : super(key: key);

  @override
  State<OrderRequestTile> createState() => _OrderRequestTileState();
}

class _OrderRequestTileState extends State<OrderRequestTile> {
  final reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 7,
      ),
      width: MediaQuery.of(context).size.width,
      // height: 120,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 235, 233, 233),
            offset: Offset(2, 2),
            blurRadius: 10)
      ]),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 0),
                  imageUrl: widget.logo,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  widget.productName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(width: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(hintText: "Review"),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: sendReview,
                child: const Text(
                  "Send",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 236, 236, 236)),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: const Size(90, 30),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                    backgroundColor: const Color.fromARGB(212, 20, 20, 20),
                    foregroundColor: const Color.fromARGB(255, 53, 53, 53)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void sendReview() async{
    User? user = FirebaseAuth.instance.currentUser;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('review')
          .doc(user!.email)
          .set({
        'comment': reviewController.text.trim(),
        'name' : user.email,
        'timestamp' : DateTime.now().toString(),
      })
          .then((value) => Navigator.pop(context))
          .then((value) => Get.snackbar("Reviewed", "Thank you for the review",
              duration: const Duration(milliseconds: 2000),
              backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
    }
  }
}
