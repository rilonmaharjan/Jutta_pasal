import 'package:flutter/material.dart';

class ColorTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final color, text, bgcolor;
  final VoidCallback onTap;
  const ColorTile(
      {Key? key,
      required this.onTap,
      required this.color,
      required this.text,
      this.bgcolor})
      : super(key: key);

  @override
  State<ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 58,
          width: 64,
          decoration: BoxDecoration(
              color: Color(int.parse(widget.bgcolor)),
              borderRadius: const BorderRadius.all(Radius.circular(100))),
          margin: const EdgeInsets.only(top: 8, bottom: 10, left: 4),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                Icons.circle,
                color: Color(int.parse(widget.color)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.text,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ));
  }
}
