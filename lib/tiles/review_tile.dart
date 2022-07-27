import 'package:flutter/material.dart';

class ReviewTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final name, time, comment;
  const ReviewTile({Key? key, this.name, this.time, this.comment})
      : super(key: key);

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 235, 233, 233),
                offset: Offset(2, 2),
                blurRadius: 10)
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.name,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Spacer(),
                  Text(widget.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.comment,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 13.5),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
