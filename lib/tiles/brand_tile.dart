import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final logo, brandName;
  final VoidCallback onTap;
  const BrandTile({Key? key, required this.onTap, this.logo, this.brandName})
      : super(key: key);

  @override
  State<BrandTile> createState() => _BrandTileState();
}

class _BrandTileState extends State<BrandTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: Align(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 0),
                  fadeOutDuration: const Duration(milliseconds: 0),
                  imageUrl: widget.logo,
                  height: 110,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.6,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(34, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
