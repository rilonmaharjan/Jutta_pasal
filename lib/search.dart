import 'package:flutter/material.dart';

import 'tabview_brands.dart';
import 'tabview_shoes.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 236, 236, 236),
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              "Search Items",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            bottom: const TabBar(
                indicatorColor: Colors.black,
                unselectedLabelColor: Color.fromARGB(255, 138, 137, 137),
                tabs: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Shoes",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Brands",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ]),
          ),
          body: const TabBarView(
            children: [
              TabViewShoes(),
              TabViewBrands(),
            ],
          )),
    );
  }
}
