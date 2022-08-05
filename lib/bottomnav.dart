import 'package:captcha/colour_view.dart';
import 'package:captcha/jutta.dart';
import 'package:captcha/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cart.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  List pages = [
    const Jutta(),

    // Search
    const ColorView(),

    //Cart
    const Cart(),

    //Profile
    const Profile(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  _handleTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      //BottomNavigation Bar
      bottomNavigationBar: BottomNavigationBar(
        onTap: _handleTap,
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 44, 44, 44),
        selectedItemColor: Colors.black,
        iconSize: 26,
        selectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.color_lens_outlined,
              ),
              label: 'Color Panel'),
          BottomNavigationBarItem(
              icon: Stack(children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("cart")
                          .doc(user!.email)
                          .collection('products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: SizedBox());
                        } else {
                          List<QueryDocumentSnapshot<Object?>> firestoreitems =
                              snapshot.data!.docs;
                          return Container(
                            padding: const EdgeInsets.all(2),
                            width: 17,
                            height: 17,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 253, 228, 213),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Text(
                              firestoreitems.length.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 8, 8, 8),
                                  fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      }),
                ),
              ]),
              label: 'Basket'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
