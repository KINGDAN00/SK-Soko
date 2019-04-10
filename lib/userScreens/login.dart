import 'package:soko/userScreens/myHomePage.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:soko/userScreens/signup.dart';

class GirliesLogin extends StatefulWidget {
  @override
  _GirliesLoginState createState() => _GirliesLoginState();
}

class _GirliesLoginState extends State<GirliesLogin> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();
  String nom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    nom = await getStringDataLocally(key: nom);
    if (nom != null)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Se connecter"),
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
                textHint: "username",
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
            appButton(
                btnTxt: "Se connecter",
                onBtnclicked: verifyLoggin,
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor),
            new GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new SignUp()));
              },
              child: new Text(
                "Pas encore inscrit? Inscrivez-vous ici",
                style: new TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  verifyLoggin() async {
    if (username.text == "") {
      showSnackBar("username ne peut pas etre vide", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("Password ne peut pas etre vide", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    String response = await appMethod.logginUser(
        username: username.text.toLowerCase(),
        password: password.text.toLowerCase());
    if (response == successful) {
      print("okay");
      closeProgressDialog(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new MyHomePage()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
