import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SuperAdminUserEditPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final name, email, phoneNumber, role, adminRole;
  const SuperAdminUserEditPage({
    Key? key,
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.adminRole,
  }) : super(key: key);

  @override
  State<SuperAdminUserEditPage> createState() => _SuperAdminUserEditPageState();
}

class _SuperAdminUserEditPageState extends State<SuperAdminUserEditPage> {
  File? file;
  final box = GetStorage();

  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    nameController.text = widget.name;
    emailController.text = widget.email;
    phoneController.text = widget.phoneNumber;
    roleController.text = widget.role;
    adminRoleController.text = widget.adminRole;
    super.initState();
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  final adminRoleController = TextEditingController();

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
              onTap: () => deleteProduct(context),
              child: const Icon(
                Icons.delete,
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
                        'Loading...',
                      );
                    } else {
                      return Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration:
                                const InputDecoration(labelText: "User Name"),
                          ),
                          TextFormField(
                            controller: emailController,
                            readOnly: true,
                            decoration:
                                const InputDecoration(labelText: "User Email"),
                          ),
                          TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                                labelText: "Phone NUmber"),
                          ),
                          TextFormField(
                            controller: roleController,
                            decoration:
                                const InputDecoration(labelText: "User Role"),
                          ),
                          TextFormField(
                            controller: adminRoleController,
                            decoration:
                                const InputDecoration(labelText: "Admin Role"),
                          ),
                        ],
                      );
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    update(context);
                  },
                  child: const Text("Edit"))
            ],
          ),
        ),
      ),
    );
  }

  Future update(context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      DocumentReference documentReferencer =
          FirebaseFirestore.instance.collection('users').doc(widget.email);
      Map<String, dynamic> data = <String, dynamic>{
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'role': roleController.text.trim(),
        'adminrole': adminRoleController.text.trim()
      };
      await documentReferencer
          .update(data)
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
  }

  Future deleteProduct(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .delete()
        .then(((value) => Get.back()))
        .then(((value) => Get.back()))
        .then((value) => Get.snackbar('Deleted', 'Successfully Deleted',
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)));
  }
}
