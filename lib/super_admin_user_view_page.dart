import 'package:captcha/super_admin_user_edit_page.dart';
import 'package:captcha/tiles/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperAdminUserViewPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables

  const SuperAdminUserViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SuperAdminUserViewPage> createState() => _SuperAdminUserViewPageState();
}

class _SuperAdminUserViewPageState extends State<SuperAdminUserViewPage> {
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  var name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 21,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              controller: nameHolder,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 46, 46, 46),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromARGB(185, 44, 44, 44),
                    ),
                    onPressed: clearTextInput,
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: (name != "")
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isGreaterThanOrEqualTo: name)
                    .where('email', isLessThan: name + 'z')
                    .snapshots()
                : FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?>? firestoreusers =
                            snapshot.data?.docs[index];
                        return UserTile(
                          adminRole: firestoreusers!['adminrole'].toString(),
                          email: firestoreusers['email'].toString(),
                          name: firestoreusers['name'].toString(),
                          phoneNumber: firestoreusers['phoneNumber'].toString(),
                          role: firestoreusers['role'].toString(),
                          onTap: () {
                            Get.to(SuperAdminUserEditPage(
                              adminRole: firestoreusers['adminrole'].toString(),
                              email: firestoreusers['email'].toString(),
                              name: firestoreusers['name'].toString(),
                              phoneNumber:
                                  firestoreusers['phoneNumber'].toString(),
                              role: firestoreusers['role'].toString(),
                            ));
                          },
                        );
                      });
            }),
      ),
    );
  }
}
