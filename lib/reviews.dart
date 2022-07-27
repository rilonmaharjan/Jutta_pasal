import 'package:captcha/tiles/review_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final productID;
  const Reviews({Key? key, this.productID}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Reviews",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        elevation: 1.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .doc(widget.productID)
                  .collection('review')
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
                      scrollDirection: Axis.vertical,
                      itemCount: firestoreitems.length,
                      itemBuilder: (context, index) {
                        return ReviewTile(
                            comment: firestoreitems[index]['comment'],
                            name: firestoreitems[index]['name'],
                            time: firestoreitems[index]['timestamp']);
                      });
                }
              }),
        ),
      )),
    );
  }
}
