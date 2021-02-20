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

  @override
  void initState() {
    super.initState();
  }

  bool validateString(String s) {
    return int.tryParse(s) != null;
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
                  backgroundColor: Colors.transparent,
                  appContext: context,
                  length: 4,
                  obscureText: true,
                  blinkWhenObscuring: true,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  validator: (v) {
                    bool isValid = true;
                    if (v.length > 0) isValid = validateString(v);
                    if (isValid) {
                      return null;
                    } else {
                      return "Invalid entry";
                    }
                  },
                  pinTheme: PinTheme(
                    inactiveColor: Colors.black,
                    activeColor: Colors.black,
                    selectedColor: Theme.of(context).accentColor,
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 60,
                    fieldWidth: 50,
                  ),
                  cursorColor: Theme.of(context).accentColor,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle:
                      TextStyle(fontSize: 20, height: 1.6, color: Colors.black),
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.phone,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    //print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: FlatButton(
                child: Text(
                  "Clear",
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  textEditingController.clear();
                },
              )),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(height: 50),
          Container(width: 200,
            child: FlatButton(color: Colors.blue,textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text("Confirm"),
              onPressed: () async {
                var formBool = formKey.currentState.validate();
                //var authenticated = await User.authenticate(currentText);
                // conditions for validating
                if (currentText.length != 4 ||
                    !validateString(currentText) ||
                    !formBool) {
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
