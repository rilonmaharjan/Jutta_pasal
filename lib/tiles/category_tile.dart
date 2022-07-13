import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final categoryName, textSize, textColor, color;
  final VoidCallback? onTap;
  const CategoryTile(
      {Key? key,
      this.categoryName,
      this.textSize,
      this.textColor,
      this.color,
      this.onTap})
      : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 80,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
          decoration: BoxDecoration(
              color: Color(int.parse(widget.color)),
              borderRadius: const BorderRadius.all(Radius.circular(17))),
          child: Text(
            widget.categoryName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: widget.textSize,
                color: Color(int.parse(widget.textColor)),
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
