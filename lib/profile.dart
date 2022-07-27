import 'package:captcha/change_password.dart';
import 'package:captcha/notification.dart';
import 'package:captcha/permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'provider/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black, size: 25),
          actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Row(
            children: const [
              SizedBox(
                width: 8,
              ),
              Text(
                "Profile and Settings",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
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
                        List<QueryDocumentSnapshot<Object?>> firestoreItems =
                            snapshot.data!.docs;
                        nameController.text = firestoreItems[0]['name'];
                        phoneController.text = firestoreItems[0]['phoneNumber'];
                        return GestureDetector(
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Edit Info",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          hintText: "Full Name",
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (contact) => contact!.isEmpty
                                            ? "Contact cannot be empty."
                                            : null,
                                      ),
                                      firestoreItems[0]['phoneNumber'] == ""
                                          ? const SizedBox()
                                          : TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              controller: phoneController,
                                              decoration: const InputDecoration(
                                                hintText: "Phone Number",
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (contact) => contact!
                                                      .isEmpty
                                                  ? "Contact cannot be empty."
                                                  : null,
                                            ),
                                    ],
                                  ),
                                ),
                                content: ElevatedButton(
                                  onPressed: () {
                                    updateProfile(context);
                                  },
                                  child: const Text("Save",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 238, 238, 238),
                                      )),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(150, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                      onPrimary: const Color.fromARGB(
                                          255, 184, 183, 183),
                                      primary: Colors.black),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 24, right: 24, bottom: 12, top: 35),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                top: 21, bottom: 18, left: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 235, 233, 233),
                                      offset: Offset(2, 2),
                                      blurRadius: 3)
                                ]),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      firestoreItems[0]['name'],
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      firestoreItems[0]['email'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 138, 137, 137)),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    firestoreItems[0]['phoneNumber'] == ""
                                        ? const SizedBox()
                                        : Text(
                                            "Contact :" +
                                                firestoreItems[0]
                                                    ['phoneNumber'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromARGB(
                                                    255, 138, 137, 137)),
                                          ),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Color.fromARGB(255, 121, 120, 120),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Notificason());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 21, bottom: 18),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 0)
                    ]),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.notifications,
                          color: Color.fromARGB(255, 121, 120, 120),
                          size: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Notifications", style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Color.fromARGB(255, 121, 120, 120),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 21, bottom: 18),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 3)
                    ]),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.history_sharp,
                          color: Color.fromARGB(255, 121, 120, 120),
                          size: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Order History", style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Color.fromARGB(255, 121, 120, 120),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 21, bottom: 18),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 235, 233, 233),
                        offset: Offset(2, 2),
                        blurRadius: 3)
                  ]),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Accounts",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 92, 92, 92)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.snackbar('Sorry', 'Not Available At the moment',
                              duration: const Duration(milliseconds: 2000),
                              backgroundColor:
                                  const Color.fromARGB(126, 255, 255, 255));
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.business_rounded,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Business Profile",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
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
                              List<QueryDocumentSnapshot<Object?>>
                                  firestoreItems = snapshot.data!.docs;
                              return firestoreItems[0]['phoneNumber'] == ""
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          indent: 13,
                                          endIndent: 13,
                                          thickness: 0.3,
                                          color: Color.fromARGB(
                                              255, 199, 199, 199),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => const ChangePassword());
                                          },
                                          child: Row(
                                            children: const [
                                              SizedBox(
                                                width: 18,
                                              ),
                                              Icon(
                                                Icons.security,
                                                color: Color.fromARGB(
                                                    255, 121, 120, 120),
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text("Security",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                            }
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 21, bottom: 18),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 235, 233, 233),
                        offset: Offset(2, 2),
                        blurRadius: 3)
                  ]),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Settings",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 92, 92, 92)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.snackbar('Sorry', 'Not Available At the moment',
                              duration: const Duration(milliseconds: 2000),
                              backgroundColor:
                                  const Color.fromARGB(126, 255, 255, 255));
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.language,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Language", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const Permissions());
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.back_hand_outlined,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Permissions", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 21, bottom: 18),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 235, 233, 233),
                        offset: Offset(2, 2),
                        blurRadius: 3)
                  ]),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "More",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 92, 92, 92)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          String phoneUrl = "tel:+977 9861333461";
                          launchUrl(Uri.parse(phoneUrl));
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.phone_in_talk,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Help", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          String googlePlayLaunch =
                              "market://details?id=com.westbund.heros";
                          launchUrl(Uri.parse(googlePlayLaunch));
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 18,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Rate Us", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          String mailUrl =
                              "mailto:rilon.maharjan@gmail.com?subject=Feedback to JuttaPasal&body=";
                          launchUrl(Uri.parse(mailUrl));
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.feedback,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 18,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Feedback", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 13,
                        endIndent: 13,
                        thickness: 0.3,
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                "Jutta has developed to incorporate many superb takeout areas in Kathmandu with additional to come sooner rather than later. Our group takes pride in the way that we can furnish our new and faithful clients with extraordinary International brands that is not normal for that at some other Nepali shops you visit. Just sit back, relax and wait for your order to arrive.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 151, 150, 150)),
                              ),
                              content: Image.asset(
                                "assets/images/logo1.png",
                                height: 20,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 12, top: 20),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18,
                            ),
                            Icon(
                              Icons.info_outline,
                              color: Color.fromARGB(255, 121, 120, 120),
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("About Us", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogout();
                    FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 21, bottom: 18),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 235, 233, 233),
                          offset: Offset(2, 2),
                          blurRadius: 3)
                    ]),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 121, 120, 120),
                          size: 18,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Log Out", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 13,
                  ),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 235, 233, 233),
                        offset: Offset(2, 2),
                        blurRadius: 3)
                  ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              String url =
                                  "https://www.facebook.com/rilonmhrzn/";
                              launchUrl(Uri.parse(url));
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.facebook,
                              size: 25,
                              color: Color.fromARGB(237, 33, 149, 243),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              String url =
                                  "https://www.youtube.com/channel/UC18AKFbWJ3Wg_op3pbTvR_Q";
                              launchUrl(Uri.parse(url));
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.youtube,
                              size: 25,
                              color: Color.fromARGB(206, 244, 67, 54),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              String url = "https://twitter.com/Rilon_mhrzn";
                              launchUrl(Uri.parse(url));
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.twitter,
                              size: 25,
                              color: Color.fromARGB(202, 33, 149, 243),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              String url =
                                  "https://www.instagram.com/rilon.maharjan/";
                              launchUrl(Uri.parse(url));
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.instagram,
                              size: 25,
                              color: Color.fromARGB(255, 255, 153, 0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Center(
                        child: Text(
                          "Developed by WeebTech",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 156, 155, 155)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child: Text(
                          "Version 1.0.0",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 156, 155, 155)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future updateProfile(context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

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
        'name': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
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
}
