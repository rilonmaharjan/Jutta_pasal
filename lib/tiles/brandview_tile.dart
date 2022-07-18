import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandViewTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final image, logo;
  final VoidCallback onTap;
  const BrandViewTile({Key? key, required this.onTap, this.image, this.logo})
      : super(key: key);

  @override
  State<BrandViewTile> createState() => _BrandViewTileState();
}

class _BrandViewTileState extends State<BrandViewTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 0),
              fadeOutDuration: const Duration(milliseconds: 0),
              imageUrl: widget.image,
              width: MediaQuery.of(context).size.width,
              height: 182,
              fit: BoxFit.cover,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 182,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(88, 185, 185, 185)),
              child: Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: widget.logo,
                    height: 110,
                    width: 110,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
