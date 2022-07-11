import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AdminUploadPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final brandUploadName;
  const AdminUploadPage({Key? key, this.brandUploadName}) : super(key: key);

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  File? file;
  final box = GetStorage();

  @override
  void initState() {
    brandController.text = widget.brandUploadName;
    super.initState();
  }

  @override
  void dispose() {
    widget.brandUploadName;
    super.dispose();
  }

  final brandController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  clearTextInput() {
    titleController.clear();
    descController.clear();
    categoryController.clear();
    priceController.clear();
    discountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: clearTextInput,
              child: const Icon(
                Icons.clear,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where('email', isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      'No User Data...',
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreItems =
                        snapshot.data!.docs;
                    return firestoreItems[0]['adminrole'] == 'superAdmin'
                        ? Column(
                            children: [
                              TextFormField(
                                controller: brandController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Brand/Store Name"),
                              ),
                              TextFormField(
                                controller: titleController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Product Name"),
                              ),
                              TextFormField(
                                controller: descController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: "Description"),
                              ),
                              TextFormField(
                                controller: categoryController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Category"),
                              ),
                              TextFormField(
                                controller: priceController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "Price"),
                              ),
                              TextFormField(
                                controller: discountController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.go,
                                decoration: const InputDecoration(
                                    labelText: "Discount"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.camera);
                                      },
                                      child: const Text("Camera")),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: const Text("Gallery"))
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              TextFormField(
                                controller: brandController,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Brand/Store Name"),
                              ),
                              TextFormField(
                                controller: titleController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Product Name"),
                              ),
                              TextFormField(
                                controller: descController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: "Description"),
                              ),
                              TextFormField(
                                controller: categoryController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    labelText: "Category"),
                              ),
                              TextFormField(
                                controller: priceController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "Price"),
                              ),
                              TextFormField(
                                controller: discountController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.go,
                                decoration: const InputDecoration(
                                    labelText: "Discount"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.camera);
                                      },
                                      child: const Text("Camera")),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: const Text("Gallery"))
                                ],
                              )
                            ],
                          );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  upload(context);
                },
                child: const Text("Upload"))
          ],
        ),
      )),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file = File(image.path);
        box.write("a", file);
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to upload image: $e");
    }
  }

  Future upload(context) async {
    String url;
    if (file == null) {
      // updates without changing image
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
        var docid = FirebaseFirestore.instance.collection('products').doc().id;
        DocumentReference documentReferencer =
            FirebaseFirestore.instance.collection('products').doc(docid);
        Map<String, dynamic> data = <String, dynamic>{
          'brand_store': brandController.text,
          'productName': titleController.text,
          'description': descController.text,
          'category': categoryController.text,
          'price': priceController.text,
          'discount': discountController.text,
          'productID': docid.trim(),
        };
        await documentReferencer
            .set(data)
            .then(((value) => Get.back()))
            .then(((value) => Get.back()))
            .then((value) => Get.snackbar('Success', 'Successfully Edited',
                duration: const Duration(milliseconds: 2000),
                backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
      } on FirebaseException catch (e) {
        Get.snackbar('Error', e.message.toString(),
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
      }
    } else {
      // updates all
      final fileName = basename(file!.path);
      final destination = 'images/$fileName';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(File(file!.path));
        uploadTask.whenComplete(() async {
          url = await ref.getDownloadURL();

          var docid =
              FirebaseFirestore.instance.collection('products').doc().id;
          DocumentReference documentReferencer =
              FirebaseFirestore.instance.collection('products').doc(docid);
          Map<String, dynamic> data = <String, dynamic>{
            'brand_store': brandController.text,
            'productName': titleController.text,
            'description': descController.text,
            'category': categoryController.text,
            'price': priceController.text,
            'discount': discountController.text,
            'image': url,
            'productID': docid.trim(),
          };
          await documentReferencer
              .set(data)
              .then(((value) => Get.back()))
              .then(((value) => Get.back()))
              .then((value) => Get.snackbar('Success', 'Successfully Edited',
                  duration: const Duration(milliseconds: 2000),
                  backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
        });
      } on FirebaseException catch (e) {
        // ignore: avoid_print
        print(e);

        Get.snackbar('Error', e.message.toString(),
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
      }
    }
  }
}
