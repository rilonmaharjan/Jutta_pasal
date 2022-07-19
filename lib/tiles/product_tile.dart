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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.image,
                      width: MediaQuery.of(context).size.width / 2.125,
                      fit: BoxFit.cover,
                    ),
                    widget.discount.isEmpty
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 55,
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 36, 36, 36),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30))),
                              child: Text(
                                widget.discount + "% off",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.desc,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          widget.discount.isEmpty
                              ? RichText(
                                  text: TextSpan(
                                      text: "Rs.",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 37, 37, 37)),
                                      children: [
                                      TextSpan(
                                        text: widget.price,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ]))
                              : RichText(
                                  text: TextSpan(
                                      text: "Rs.",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 37, 37, 37)),
                                      children: [
                                      TextSpan(
                                        text:
                                            "${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ])),
                          const SizedBox(
                            width: 10,
                          ),
                          widget.discount.isEmpty
                              ? const SizedBox()
                              : Text(
                                  "Rs." + widget.price,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 139, 139, 139),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
