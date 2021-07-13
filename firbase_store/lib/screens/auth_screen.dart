import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  String _verificationID = '';

  void _submitAuthForm(
    String email,
    String phoneNumber,
    bool isPhoneNumber,
    BuildContext ctx,
  ) async {
    var authR;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isPhoneNumber) {
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationID,
          smsCode: '',
        );
        await _auth.signInWithPhoneNumber(phoneNumber);
        _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (AuthCredential authCredential) {
            _auth.signInWithCredential(authCredential);
          },
          verificationFailed: (FirebaseAuthException authException) {},
          codeSent: (String verificationId, int? forceResendingToken) {
            _verificationID = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
            print(verificationId);
            print("Timout");
          },
        );
      } else {
        await _auth.signInWithPhoneNumber(phoneNumber);
      }
    } on PlatformException catch (err) {
      String? message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
