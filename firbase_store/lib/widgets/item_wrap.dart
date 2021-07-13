import 'package:flutter/material.dart';

class ItemWrap extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String desc;
  final Key? key;

  ItemWrap(this.image, this.title, this.price, this.desc, {this.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text(title), Text(price)],
          ),
          Divider(),
          Text(desc)
        ],
      ),
    );
  }
}
