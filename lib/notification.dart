import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'refresh.dart';

class Notificason extends StatefulWidget {
  const Notificason({Key? key}) : super(key: key);

  @override
  State<Notificason> createState() => _NotificasonState();
}

class _NotificasonState extends State<Notificason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Notifications",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          elevation: 2.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
            child: Refresher(
          refreshbody: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color.fromARGB(255, 244, 246, 252),
              height: MediaQuery.of(context).size.height / 1.12,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo1.png",
                    height: 150,
                    width: 150,
                  ),
                  const Text(
                    "Notification will appear here",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    "We will notify you when something new and\ninteresting is happening",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 15,
                        color: Color.fromARGB(255, 127, 129, 128)),
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
          refreshitem: const SpinKitHourGlass(
            duration: Duration(milliseconds: 1000),
            color: Color.fromARGB(255, 199, 228, 255),
            size: 25.0,
          ),
        )));
  }
}
