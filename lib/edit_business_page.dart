// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditBusinessPage extends StatefulWidget {
  final brandName, contact, location, website;
  const EditBusinessPage(
      {Key? key,
      required this.brandName,
      this.contact,
      this.location,
      this.website})
      : super(key: key);

  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  File? file;
  File? file2;
  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  String datetime = DateTime.now().toString();

  final storeNameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();

  clearTextInput() {
    storeNameController.clear();
    contactController.clear();
    locationController.clear();
    websiteController.clear();
  }

  @override
  void initState() {
    storeNameController.text = widget.brandName;
    contactController.text = widget.contact;
    locationController.text = widget.location;
    websiteController.text = widget.website;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: const Text(
          "Edit Business Profile",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 115,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: storeNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Store Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 253, 50, 50))),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: contactController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Contact",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value != null && value.isEmpty)
                              ? 'Location Must Not be Empty'
                              : null,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: locationController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value != null && value.isEmpty)
                              ? 'Location Must Not be Empty'
                              : null,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: websiteController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "Website (Optional)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickImageforlogo(ImageSource.gallery);
                          },
                          child: const Text(
                            "Edit Logo",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              fixedSize: const Size(285, 50),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                              primary: const Color.fromARGB(255, 253, 253, 253),
                              onPrimary: const Color.fromARGB(255, 53, 53, 53)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickImageforCover(ImageSource.gallery);
                          },
                          child: const Text(
                            "Edit Cover Image",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              fixedSize: const Size(285, 50),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                              primary: const Color.fromARGB(255, 253, 253, 253),
                              onPrimary: const Color.fromARGB(255, 53, 53, 53)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            update(context);
                          },
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              fixedSize: const Size(285, 50),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                              primary: const Color.fromARGB(255, 181, 210, 255),
                              onPrimary: const Color.fromARGB(255, 53, 53, 53)),
                        )
                        //imagepending
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color.fromARGB(26, 240, 108, 126),
                    ),
                    child: const Text(
                      "To change store name contact to service, go to Help in Settings.",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 206, 29, 16),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageforlogo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file = File(image.path);
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to upload image: $e");
    }
  }

  Future pickImageforCover(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file2 = File(image.path);
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to upload image: $e");
    }
  }

  Future update(context) async {
    String urlLogo;
    String urlCover;
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (file == null) {
      // updates without changing logo
      final fileName = basename(file2!.path);
      final destination = 'images/$fileName';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(File(file2!.path));
        uploadTask.whenComplete(() async {
          urlLogo = await ref.getDownloadURL();
          DocumentReference documentReferencer =
              FirebaseFirestore.instance.collection('users').doc(user!.email);
          Map<String, dynamic> data = <String, dynamic>{
            'adminrole': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'cover image': urlLogo,
          };
          DocumentReference documentReferencer2 =
              FirebaseFirestore.instance.collection('brand').doc(user!.email);
          Map<String, dynamic> data2 = <String, dynamic>{
            'brand_name': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'image': urlLogo
          };
          await documentReferencer.update(data);

          await documentReferencer2
              .update(data2)
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
    //cover image is empty
    else if (file2 == null) {
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
          urlLogo = await ref.getDownloadURL();
          DocumentReference documentReferencer =
              FirebaseFirestore.instance.collection('users').doc(user!.email);
          Map<String, dynamic> data = <String, dynamic>{
            'adminrole': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'logo': urlLogo
          };
          DocumentReference documentReferencer2 =
              FirebaseFirestore.instance.collection('brand').doc(user!.email);
          Map<String, dynamic> data2 = <String, dynamic>{
            'brand_name': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'logo': urlLogo
          };
          await documentReferencer.update(data);

          await documentReferencer2
              .update(data2)
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
    // cover and logo is empty
    else if (file == null && file2 == null) {
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
        DocumentReference documentReferencer =
            FirebaseFirestore.instance.collection('users').doc(user!.email);
        Map<String, dynamic> data = <String, dynamic>{
          'adminrole': storeNameController.text.trim(),
          'location': locationController.text.trim(),
          'website': websiteController.text.trim(),
          'store_contact': contactController.text.trim(),
        };
        DocumentReference documentReferencer2 =
            FirebaseFirestore.instance.collection('brand').doc(user!.email);
        Map<String, dynamic> data2 = <String, dynamic>{
          'brand_name': storeNameController.text.trim(),
          'location': locationController.text.trim(),
          'website': websiteController.text.trim(),
          'store_contact': contactController.text.trim(),
        };
        await documentReferencer.update(data);

        await documentReferencer2
            .update(data2)
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

      final fileCoverName = basename(file2!.path);
      final destinationCover = 'images/$fileCoverName';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(File(file!.path));

        final refCover = FirebaseStorage.instance.ref(destinationCover);
        UploadTask uploadCover = refCover.putFile(File(file2!.path));

        uploadCover.whenComplete(() async {
          urlCover = await refCover.getDownloadURL();
          DocumentReference documentReferencer =
              FirebaseFirestore.instance.collection('users').doc(user!.email);
          Map<String, dynamic> data = <String, dynamic>{
            'adminrole': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'cover image': urlCover
          };
          DocumentReference documentReferencer2 =
              FirebaseFirestore.instance.collection('brand').doc(user!.email);
          Map<String, dynamic> data2 = <String, dynamic>{
            'brand_name': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'image': urlCover
            //imagepending
          };
          await documentReferencer.update(data);

          await documentReferencer2
              .update(data2)
              .then(((value) => Get.back()))
              .then(((value) => Get.back()))
              .then((value) => Get.snackbar('Success', 'Successfully Edited',
                  duration: const Duration(milliseconds: 2000),
                  backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
        });

        uploadTask.whenComplete(() async {
          urlLogo = await ref.getDownloadURL();
          DocumentReference documentReferencer =
              FirebaseFirestore.instance.collection('users').doc(user!.email);
          Map<String, dynamic> data = <String, dynamic>{
            'adminrole': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'logo': urlLogo
            //imagepending
          };
          DocumentReference documentReferencer2 =
              FirebaseFirestore.instance.collection('brand').doc(user!.email);
          Map<String, dynamic> data2 = <String, dynamic>{
            'brand_name': storeNameController.text.trim(),
            'location': locationController.text.trim(),
            'website': websiteController.text.trim(),
            'store_contact': contactController.text.trim(),
            'logo': urlLogo
            //imagepending
          };
          await documentReferencer.update(data);

          await documentReferencer2
              .update(data2)
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
