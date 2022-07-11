// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  final image, desc, title, price, discount;
  final VoidCallback? onTap;
  const ProductTile(
      {Key? key,
      this.image,
      this.title,
      this.price,
      this.discount,
      this.desc,
      this.onTap})
      : super(key: key);

  @override
  State<ProductTile> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2.125,
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.image,
                  width: MediaQuery.of(context).size.width / 2.125,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.title),
                Text(widget.desc),
                widget.discount.isEmpty
                    ? Text("Rs. " + widget.price)
                    : Column(
                        children: [
                          Text(
                              "Rs. ${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}"),
                          RichText(
                            text: TextSpan(
                              text: "Rs. " + widget.price,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 139, 139, 139),
                                decoration: TextDecoration.lineThrough,
                              ),
                              children: [
                                TextSpan(
                                  text: "    -" + widget.discount + "%",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 139, 139, 139),
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}
