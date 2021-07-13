import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_store/screens/about_item.dart';
import 'package:firbase_store/screens/add_item.dart';
import 'package:firbase_store/widgets/item_wrap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (ctx, AsyncSnapshot chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          return GridView.builder(
              itemCount: chatDocs.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AboutItem.routName, arguments: {
                      'image': chatDocs[index].data()['image'],
                      'title': chatDocs[index].data()['title'],
                      'price': chatDocs[index].data()['price'],
                      'desc': chatDocs[index].data()['desc'],
                    });
                  },
                  child: Container(
                    child: Hero(
                      tag: chatDocs[index].data()['image'],
                      child: Image.network(
                        chatDocs[index].data()['image'],
                        fit: BoxFit.fill,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                );
              });
          // return ListView.builder(
          //   itemCount: chatDocs.length,
          //   itemBuilder: (ctx, index) => ItemWrap(
          //     chatDocs[index].data()['image'],
          //     chatDocs[index].data()['title'],
          //     chatDocs[index].data()['price'],
          //     chatDocs[index].data()['desc'],
          //     key: ValueKey(chatDocs[index].id),
          //   ),
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed(AddItem.routName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
