import 'package:captcha/jutta.dart';
import 'package:captcha/profile.dart';
import 'package:captcha/view/search.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'view/search_products.dart';

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
  List pages = [
    const Jutta(),

    // Search
    const SearchView(),

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: 'Basket'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
