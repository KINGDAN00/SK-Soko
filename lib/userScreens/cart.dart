import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:soko/userScreens/myHomePage.dart';

class GirliesCart extends StatefulWidget {
  @override
  _GirliesCartState createState() => _GirliesCartState();
}

class _GirliesCartState extends State<GirliesCart> {
  String aimage, anom, _message = "loading...";
  double aqte, aprix, atotal = 0.0;
  DateTime date = DateTime.now();
  AppMethods appMethods = new FirebaseMethods();
  List<dynamic> data = new List();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Text('Soko panier')),
        leading: Center(child: Icon(Icons.shopping_basket)),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              clearCart();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.check,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: data.length == 0
          ? Center(
              child: Text(
              _message,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                //  if(data.length == 0) return Center(child:Text('loading...'));
                for (Map<String, dynamic> items in data) {
                  atotal += items[prix];
                 
                }
                Map<String, dynamic> item = data[index];
                anom = item[titre].toString().toUpperCase();
                List<dynamic> list = new List.from(item[image]);
                aimage = list[0]["image1"];
                aprix = item[prix];
                aqte = item[quantite];
                print("Date from firesbase ${item[create_at]}");

                // date = DateTime.fromMicrosecondsSinceEpoch(item[create_at]);
                return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                        key: ValueKey('id'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60.0,
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 30.0),
                                      loadMinim(
                                          context,
                                          aimage == null
                                              ? 'https://www.swissluxury.com/product_images/126334bkdo.jpg'
                                              : aimage),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      anom == null
                                                          ? 'nom'
                                                          : anom,
                                                      style: localTheme
                                                          .textTheme.subhead
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                ),
                                                Text(aprix == 0.0
                                                    ? '0.0 Fc'
                                                    : "${aprix.toString()} FC"),
                                              ],
                                            ),
                                            Text(aqte == 0.0
                                                ? '0.0 '
                                                : "${aqte.toString()}"),
                                            Text(
                                              date.toLocal().toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Divider(
                                    color: Colors.black,
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]));
              },
            ),
      // bottomNavigationBar:BottomNavigationBar(
      //   onTap: (int index){},
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: 0,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.check,
      //         color: Color(0xFFE52020),
      //       ),
      //       title: Text("Valider",
      //           style: TextStyle(
      //               color: Color(0xFFE52020) ))
      //      ),
      //      BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.check,
      //         color: Color(0xFFE52020),
      //       ),
      //       title: Text("Valider",
      //           style: TextStyle(
      //               color: Color(0xFFE52020) ))
      //      )
      //   ],
      // ),
      //,
    );
  }

  void getData() async {
    // displayProgressDialog(context);
    data = await appMethods.getCart();
    if (data.length == 0) _message = "Panier vide";
    setState(() {});
  }

  void verifyDetails() {}

  void clearCart() async {
    if (data.length == 0) {
      showSnackBar(
          "Une requete est encours, ou le panier est vide", scaffoldKey);
      return;
    }
    displayProgressDialog(context);
    String response = await appMethods.deleteCart();
    if (response == successful) {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new MyHomePage()));
      // print("okay okay");
      // closeProgressDialog(context);
      // Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (BuildContext context)=>new GirliesLogin()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
