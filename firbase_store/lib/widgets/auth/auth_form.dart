import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );
  final bool isLoading;
  final void Function(
    String phoneNumber,
    String email,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isPhone = true;
  var _userEmail = '';
  var _userPhone = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    print(isValid);

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPhone.trim(),
        _isPhone,
        context,
      );
      print(_userPhone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isPhone)
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                  if (_isPhone)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Phone'),
                      onSaved: (value) {
                        _userPhone = value!;
                      },
                    ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text('Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text(!_isPhone
                          ? 'SignUp with phone number'
                          : 'SignUp with Google'),
                      onPressed: () {
                        setState(() {
                          _isPhone = !_isPhone;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
