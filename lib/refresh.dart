// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatefulWidget {
  final refreshbody, refreshitem;
  const Refresher(
      {Key? key, required this.refreshbody, required this.refreshitem})
      : super(key: key);

  @override
  State<Refresher> createState() => _RefresherState();
}

RefreshController _refreshController = RefreshController(initialRefresh: false);

void _onRefresh() async {
  // monitor network fetch
  await Future.delayed(const Duration(milliseconds: 3000));
  // if failed,use refreshFailed()
  _refreshController.refreshCompleted();
}

class _RefresherState extends State<Refresher> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: CustomHeader(builder: (context, mode) {
          return SizedBox(
            height: 55.0,
            child: Center(child: widget.refreshitem),
          );
        }),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: [widget.refreshbody],
        ));
  }
}
