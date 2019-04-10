import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:soko/userScreens/cart.dart';

class ItemDetail extends StatefulWidget {
  String itemName;
  String itemImage;
  String itemSubName;
  double itemPrice;
  double itemRating;
  List<dynamic> images;
  String itemId;
  ItemDetail(
      {this.itemId,
      this.itemName,
      this.itemImage,
      this.itemRating,
      this.itemPrice,
      this.itemSubName,
      this.images});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  TextEditingController qte = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AppMethods appMethod = new FirebaseMethods();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String selectImageUrl = widget.itemImage;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.itemName),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 300.0,
            decoration: new BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: new BorderRadius.only(
                  bottomRight: new Radius.circular(120.0),
                  bottomLeft: new Radius.circular(120.0),
                )),
          ),
          new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Container(
                  height: 300.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new NetworkImage(selectImageUrl),
                        fit: BoxFit.cover),
                  ),
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          widget.itemName,
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          widget.itemName,
                          style: new TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w400),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                  size: 20.0,
                                ),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "${widget.itemRating}",
                                  style: new TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                            new Text(
                              "${widget.itemPrice} Fc",
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red[500],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    height: 150.0,
                    child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          String path = "image${index + 1}";
                          return new Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    print("is clicked");
                                    setState(() {
                                      selectImageUrl =
                                          widget.images[index][path];
                                      print("is clicked");
                                    });
                                  },
                                  child: new Container(
                                    margin: new EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    height: 140.0,
                                    width: 100.0,
                                    child: new Image.network(
                                        widget.images[index][path]),
                                  )),
                              new Container(
                                margin:
                                    new EdgeInsets.only(left: 5.0, right: 5.0),
                                height: 140.0,
                                width: 100.0,
                                decoration: new BoxDecoration(
                                    color: Colors.grey.withAlpha(50)),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          "Description",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          widget.itemSubName,
                          style: new TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w400),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        color: Theme.of(context).primaryColor,
        elevation: 0.0,
        shape: new CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: new Container(
          height: 50.0,
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                },
                child: new Container(
                  width: (screenSize.width - 20) / 2,
                  child: new Text(
                    "AJOUTER AUX FAVORIES",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: new Container(
                  width: (screenSize.width - 20) / 2,
                  child: new Text(
                    "AJOUTER A LA CARTE",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: EdgeInsets.only(top : 13.0, bottom: 5.0, left: 5.0),
                child: Text(
                  'Quantite',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              appTextField(
                  isPassword: false,
                  sidePadding: 10,
                  textHint: "Quantite",
                  textIcon: Icons.subject,
                  textType: TextInputType.number,
                  controller: qte),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: appButton(
                    btnTxt: "Ajouter A la carte",
                    onBtnclicked: addToCart,
                    btnPadding: 10.0,
                    btnColor: Colors.blueGrey),
              ),
            ]),
          );
        });
  }

  void addToCart() async {
    Navigator.of(context).pop();
    if (qte.text.trim() == "" || qte.text.trim() == "0") {
      showSnackBar(
          "Quantite ne peut pas etre vide ou egale a zero", scaffoldKey);
      return;
    }
    displayProgressDialog(context);
    String response = await appMethod.addToCart(
        artID: widget.itemId, qte: double.parse(qte.text.trim()));

    if (response == successful) {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
