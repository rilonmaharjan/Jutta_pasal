import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
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
          "Business Profile",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: storeNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Store Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: Colors.grey)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value != null && value.isEmpty)
                        ? 'Must Not be Empty'
                        : null,
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
                          borderSide: const BorderSide(color: Colors.grey)),
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
                          borderSide: const BorderSide(color: Colors.grey)),
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
                          borderSide: const BorderSide(color: Colors.grey)),
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
                      "Upload Logo",
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
                  //imagepending
                  ElevatedButton(
                    onPressed: () {
                      upload(context);
                    },
                    child: const Text(
                      "Create Profile",
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
                ],
              ),
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

  Future upload(context) async {
    String url;
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (file == null) {
      return Get.snackbar('Store Logo Required', "Please upload store logo",
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
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

          DocumentReference documentReferencer = FirebaseFirestore.instance
              .collection('business profile requests')
              .doc(storeNameController.text);
          Map<String, dynamic> data = <String, dynamic>{
            'store/brandName': storeNameController.text,
            'contact': contactController.text,
            'location': locationController.text,
            'website': websiteController.text,
            'storeLogo': url,
            'timestamp': datetime,
            //imagepending
          };
          await documentReferencer
              .set(data)
              .then(((value) => Get.back()))
              .then(((value) => Get.back()))
              .then((value) => Get.snackbar('Success',
                  'Mail will be sent after your Business Profile is ready',
                  duration: const Duration(milliseconds: 4000),
                  backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
        });
      } on FirebaseException catch (e) {
        Get.snackbar('Error', e.message.toString(),
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
      }
    }
  }
}
