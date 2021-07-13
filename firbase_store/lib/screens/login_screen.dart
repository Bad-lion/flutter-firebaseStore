import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getMobileFormWidget(context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellowAccent.shade400,
        ),
        child: Column(
          children: [
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });

                await _auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });
                    _scaffoldKey.currentState!.showSnackBar(
                        SnackBar(content: Text(verificationFailed.message!)));
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState =
                          MobileVerificationState.SHOW_OTP_FORM_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "SEND",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellowAccent.shade400,
        ),
        child: Column(
          children: [
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otpController.text);

                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "VERIFY",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Colors.black87,
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
