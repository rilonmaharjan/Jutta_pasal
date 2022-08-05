// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowedStoreTile extends StatefulWidget {
  final logo, brandName, website, brandId;
  final VoidCallback? ontap;
  const FollowedStoreTile({
    Key? key,
    this.logo,
    this.brandName,
    this.ontap,
    this.website,
    this.brandId,
  }) : super(key: key);

  @override
  State<FollowedStoreTile> createState() => _FollowedStoreTileState();
}

class _FollowedStoreTileState extends State<FollowedStoreTile> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        margin: const EdgeInsets.only(
          top: 7,
        ),
        width: MediaQuery.of(context).size.width,
        height: 80,
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 235, 233, 233),
              offset: Offset(2, 2),
              blurRadius: 10)
        ]),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 0),
              imageUrl: widget.logo,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              widget.brandName,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => unfollow(context),
              child: const Text(
                "Unollow",
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
                  primary: const Color.fromARGB(212, 20, 20, 20),
                  onPrimary: const Color.fromARGB(255, 53, 53, 53)),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }

  Future unfollow(context) async {
    FirebaseFirestore.instance
        .collection('follow')
        .doc(user!.email)
        .collection('brands')
        .doc(widget.brandId)
        .delete()
        .then((value) => Get.snackbar('Unfollowed', 'Successfully Unfollowed',
            duration: const Duration(milliseconds: 1500),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)));
  }
}
