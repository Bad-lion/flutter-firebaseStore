import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_store/screens/home_screen.dart';
import 'package:firbase_store/widgets/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  static String routName = '/add-item';

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = '';
  String _itemPrice = '';
  String _itemDesc = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _addItem() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      final ref = FirebaseStorage.instance
          .ref()
          .child('item_image')
          .child(_itemName + '.jpg');

      await ref.putFile(_userImageFile!);

      final url = await ref.getDownloadURL();

      FirebaseFirestore.instance.collection('items').add({
        'image': url,
        'title': _itemName,
        'price': _itemPrice,
        'desc': _itemDesc
      });
      Navigator.of(context).pushNamed(HomeScreen.routName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyImagePicker(_pickedImage),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('title'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: 'Title'),
                      onSaved: (value) {
                        _itemName = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('price'),
                      validator: (value) {
                        if (value!.isEmpty || int.parse(value) < 0) {
                          return 'Please enter a correct price';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      onSaved: (value) {
                        _itemPrice = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('description'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                        _itemDesc = value!;
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: _addItem,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Text(
                          'create item',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
