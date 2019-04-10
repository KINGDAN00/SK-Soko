import 'package:soko/userScreens/login.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nom = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController re_password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Creation de Compte"),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "Nom",
                textIcon: Icons.person,
                controller: nom),
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "mobile Number",
                textIcon: Icons.phone,
                textType: TextInputType.number,
                controller: mobileNumber),
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "username ",
                textIcon: Icons.person,
                controller: username),
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "Password",
                textIcon: Icons.lock,
                controller: password),
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "Re-Password",
                textIcon: Icons.lock,
                controller: re_password),
            appButton(
                btnTxt: "Creer un Compte",
                onBtnclicked: verifyDetails,
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  verifyDetails() async {
    if (nom.text == "") {
      showSnackBar("Nom ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (mobileNumber.text == "") {
      showSnackBar("mobile ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (username.text == "") {
      showSnackBar("username ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("Password ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (re_password.text == "") {
      showSnackBar("Re-Password ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (password.text != re_password.text) {
      showSnackBar("Passwords ne correspondent pas", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    String response = await appMethod.createUserAccount(
        unom: nom.text,
        umobile: mobileNumber.text,
        uusername: username.text.toLowerCase(),
        upassword: password.text.toLowerCase());

    if (response == successful) {
      print("okay okay");
      closeProgressDialog(context);
      Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (BuildContext context)=>new GirliesLogin()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
