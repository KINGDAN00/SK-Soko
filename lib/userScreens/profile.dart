import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:soko/tools/app_data.dart';
import 'dart:ui' as ui;

import 'package:soko/userScreens/edit.dart';

class Profil extends StatefulWidget {

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  BuildContext context;
  String unom = "";
  String uusername = "";
  String uavatare = "";
  String utel = "";
  AppMethods appMethods = new FirebaseMethods();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }


  Future getCurrentUser() async {
    unom = await getStringDataLocally(key: nom);
    uusername = await getStringDataLocally(key: username);
    uavatare = await getStringDataLocally(key: avatare);
    utel = await getStringDataLocally(key: mobile);
    //print(await getStringDataLocally(key: userEmail));
    setState(() {});
  } 
 _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(),
          _buildInfo(),
        ],
      ),
    );
  }
  Widget _buildAvatar() {
    return Container(
      width: 110.0,
      height: 110.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
      ),
      margin: const EdgeInsets.only(top: 32.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: Image.network(uavatare != null ? uavatare : "http://www.coiffure-institut.com/wp-content/uploads/2017/04/17bb8d423273c7ee8ea3849d94c6692e.jpg",
        fit: BoxFit.cover,),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            unom != null ? unom + '\n' + uusername : 'username',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Text(
            utel != null ? 'Mobile: $utel' : ' Mobile : +243 99 666 23 08',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 225.0,
            height: 1.0,
          ),
          Center(
            child: Text(
              'Soko User Description comming soon',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                height: 1.4,
                fontSize: 28
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(uavatare != null ? uavatare : "http://www.coiffure-institut.com/wp-content/uploads/2017/04/17bb8d423273c7ee8ea3849d94c6692e.jpg", fit: BoxFit.cover),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: _buildContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new EditProfil()));
          },
          backgroundColor: Colors.blueAccent,
          //if you set mini to true then it will make your floating button small
          mini: false,
          child: new Icon(Icons.edit),
      ),
    );
  }
}