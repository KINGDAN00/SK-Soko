import 'dart:io';

import 'package:soko/userScreens/login.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:image_picker/image_picker.dart';

class EditProfil extends StatefulWidget {
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  TextEditingController nom = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController re_password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();
  File image;

pickImage(bool picker) async {
    File file;
    if (!picker)
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    else
      file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      image = file;
      setState(() {});
    }
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 130.0,
            color: Color(0xFF737373).withOpacity(1.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Camera'),
                    leading: Icon(Icons.camera, color: Colors.deepOrange),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(true);
                    },
                  ),
                  ListTile(
                    title: Text('Gallery'),
                    leading: Icon(Icons.folder_open, color: Colors.lightGreen),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Modifier le profile"),
        centerTitle: false,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new RaisedButton.icon(
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0))),
                onPressed: () => _showBottomSheet(),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: new Text(
                  "Add Images",
                  style: new TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 10.0,
            ),
            image != null ?
            loadImage(context, image) : 
            new SizedBox(
              height: 30.0,
            ),
            new SizedBox(
              height: 20.0,
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
                btnTxt: "Modifier le Compte",
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
    showSnackBar("Patienter le telechargement en cours...", scaffoldKey);
    String response = await appMethod.UpdateUserAccount(
        unom: nom.text,
        umobile: mobileNumber.text,
        upassword: password.text.toLowerCase(),
        image: image);

    if (response == successful) {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
      // print("okay okay");
      // closeProgressDialog(context);
      // Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (BuildContext context)=>new GirliesLogin()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
