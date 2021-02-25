import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatefulWidget {
  PinCode();

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  String validateString(String s) {
    if (s.length == 0 || int.tryParse(s) != null) {
      return null;
    } else {
      return "Invalid entry";
    }
  }

  @override
  void dispose() {
    errorController.close();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 80),
          Form(
            key: formKey,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: PinCodeTextField(
                  //General setup
                  appContext: context,
                  length: 4,
                  controller: textEditingController,
                  keyboardType: TextInputType.phone,
                  textStyle:
                      TextStyle(fontSize: 20, height: 1.6, color: Colors.black),

                  //Colors
                  backgroundColor: Colors.transparent,
                  cursorColor: Theme.of(context).accentColor,

                  //Obscuring
                  obscureText: true,
                  blinkWhenObscuring: true,
                  obscuringCharacter: '*',
                  blinkDuration: const Duration(seconds: 1),

                  //Animation
                  animationType: AnimationType.fade,
                  animationDuration: Duration(milliseconds: 300),
                  errorAnimationController: errorController,

                  //Validation
                  errorTextSpace: 25,
                  validator: (v) {
                    return validateString(v);
                  },

                  pinTheme: PinTheme(
                    inactiveColor: Colors.black,
                    activeColor: Colors.black,
                    selectedColor: Theme.of(context).accentColor,
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 60,
                    fieldWidth: 50,
                  ),
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                )),
          ),
          FlatButton(
            child: Text(
              "Clear",
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              textEditingController.clear();
            },
          ),
          Container(
            width: 200,
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text("Confirm"),
              onPressed: () {
                var formBool = formKey.currentState.validate();
                //var authenticated = await User.authenticate(currentText);
                // conditions for validating
                if (currentText.length != 4 || !formBool) {
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                } else {
                  print("Yes");
                  showAlertDialog(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Successfully logged in"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
