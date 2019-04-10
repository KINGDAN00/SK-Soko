import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:soko/adminScreens/add_products.dart';
import 'package:soko/adminScreens/admin_home.dart';
import 'package:soko/tools/Store.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:soko/userScreens/item_details.dart';
import 'package:soko/userScreens/itemdetails.dart';
import 'favorites.dart';
import 'messages.dart';
import 'cart.dart';
import 'history.dart';
import 'profile.dart';
import 'delivery.dart';
import 'aboutUs.dart';
import 'login.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext context;
  String unom = "";
  String uusername = "";
  String uavatare = "";
  bool isLoggedIn;
  Stream articles;
  double likes = 0.0;
  AppMethods appMethods = new FirebaseMethods();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Future getCurrentUser() async {
    articles = await appMethods.getArticles();
    unom = await getStringDataLocally(key: nom);
    uusername = await getStringDataLocally(key: username);
    uavatare = await getStringDataLocally(key: avatare);
    isLoggedIn = await getBoolDataLocally(key: loggedIN);
    //print(await getStringDataLocally(key: userEmail));
    unom == null ? unom = "Guest User" : unom;
    uusername == null ? uusername = "guestUser@email.com" : uusername;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: GestureDetector(
          onLongPress: openAdmin,
          child: new Text("soko"),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new GirliesFavorities()));
              }),
          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            new GirliesMessages()));
                  }),
              new CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: new Text(
                  "0",
                  style: new TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: articles,
          builder: (context, snap) {
            if (!snap.hasData) return Center(child: Text('Loading....'));
            // int count = snap.data.documents.length;
            // print("data size ${count}");
            // return Center(child: Text('Loading....'));
            // _buildBody(snap);
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snap.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                likes = snap.data.documents[index].data["likes"];
                List<dynamic> list =
                    new List.from(snap.data.documents[index].data["images"]);
                return new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new ItemDetail(
                              itemId: snap.data.documents[index].documentID,
                              itemImage: list[0]["image1"],
                              itemName:
                                  snap.data.documents[index].data["titre"],
                              itemPrice:
                                  snap.data.documents[index].data["prix"],
                              itemRating: likes,
                              itemSubName: snap
                                  .data.documents[index].data["description"],
                              images: list,
                            )));
                  },
                  child: new Card(
                    child: Stack(
                      alignment: FractionalOffset.topLeft,
                      children: <Widget>[
                        new Stack(
                          alignment: FractionalOffset.bottomCenter,
                          children: <Widget>[
                            new Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image:
                                          new NetworkImage(list[0]["image1"]))),
                            ),
                            new Container(
                              height: 35.0,
                              color: Colors.black.withAlpha(100),
                              child: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "${snap.data.documents[index].data["titre"]}...",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                          color: Colors.white),
                                    ),
                                    new Text(
                                      "${snap.data.documents[index].data["prix"].toString()} FC",
                                      style: new TextStyle(
                                          color: Colors.red[500],
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              height: 30.0,
                              width: 60.0,
                              decoration: new BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: new BorderRadius.only(
                                    topRight: new Radius.circular(5.0),
                                    bottomRight: new Radius.circular(5.0),
                                  )),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Icon(
                                    Icons.star,
                                    color: Colors.blue,
                                    size: 20.0,
                                  ),
                                  new Text(
                                    "${snap.data.documents[index].data["likes"].toString()}",
                                    style: new TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            new IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  print("Add likes");
                                  addLikes(
                                      snap.data.documents[index].documentID);
                                  print("Add likes");
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          new FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new GirliesCart()));
            },
            child: new Icon(Icons.shopping_cart),
          ),
          new CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red,
            child: new Text(
              "*",
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          )
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(unom),
              accountEmail: new Text(uusername),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: uavatare == null
                    ? new Icon(Icons.person)
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: new BoxDecoration(
                          color: Colors.grey.withAlpha(100),
                          image: new DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(uavatare)),
                        ),
                      ),
              ),
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Ajouter un produit"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (context) => AddProducts()));
              },
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Order History"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new GirliesHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Profile Settings"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Profil()));
              },
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Delivery Address"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new GirliesDelivery()));
              },
            ),
            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(
                  Icons.help,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("About Us"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new GirliesAboutUs()));
              },
              //
            ),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text(isLoggedIn == true ? "Logout" : "Login"),
              onTap: checkIfLoggedIn,
            ),
          ],
        ),
      ),
    );
  }

  checkIfLoggedIn() async {
    if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new GirliesLogin()));
      if (response == true) getCurrentUser();
      return;
    }
    bool response = await appMethods.logOutUser();
    if (response == true) getCurrentUser();
  }

  openAdmin() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new AdminHome()));
  }

  void addLikes(String id) async {
    String response = await appMethods.addLike(artId: id);
    setState(() {
      likes += 1;
    });
  }
}
