import 'package:flutter/material.dart';

class AboutItem extends StatefulWidget {
  static String routName = '/about';

  @override
  _AboutItemState createState() => _AboutItemState();
}

class _AboutItemState extends State<AboutItem> {
  late final String image;
  late final String title;
  late final String price;
  late final String desc;

  @override
  void didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    image = routeArgs['image'];
    title = routeArgs['title'];
    price = routeArgs['price'];
    desc = routeArgs['desc'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abut item'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: Hero(
              tag: image,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 28),
              ),
              Text(price, style: TextStyle(fontSize: 28)),
            ],
          ),
          Divider(),
          Text(desc)
        ],
      ),
    );
  }
}
