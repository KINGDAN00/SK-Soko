import 'dart:io';
import 'package:soko/tools/app_methods.dart';
import 'package:soko/tools/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:soko/tools/app_data.dart';
import 'package:soko/tools/app_tools.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();
  List<String> categoryKey = new List();
  Map<int, File> imagesMap = new Map();

  TextEditingController prodcutTitle = new TextEditingController();
  TextEditingController prodcutPrice = new TextEditingController();
  TextEditingController prodcutDesc = new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AppMethods appMethod = new FirebaseMethods();
  List<List<String>> data;

  @override
  void initState() {
    super.initState();
    categoryList = new List.from(localCatgeories);
    init();
    dropDownCategories = buildAndGetDropDownItems(categoryList);
    selectedCategory = dropDownCategories[0].value;
  }

  void init() async {
    data = await appMethod.getCategories();
    setState(() {
      categoryList = data[0];
      categoryKey = data[1];
      dropDownCategories = buildAndGetDropDownItems(categoryList);
      selectedCategory = dropDownCategories[0].value;
      selectedCategory = dropDownCategories[0].value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Add Products"),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: 10.0,
            ),
            MultiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                }),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
                textTitle: "Product Title",
                textHint: "Enter Product Title",
                controller: prodcutTitle),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
                textTitle: "Product Price",
                textHint: "Enter Product Price",
                textType: TextInputType.number,
                controller: prodcutPrice),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
                textTitle: "Product Description",
                textHint: "Enter Description",
                controller: prodcutDesc,
                height: 180.0),
            new SizedBox(
              height: 10.0,
            ),
            productDropDown(
                textTitle: "Product Category",
                selectedItem: selectedCategory,
                dropDownItems: dropDownCategories,
                changedDropDownItems: changedDropDownCategory),
            new SizedBox(
              height: 10.0,
            ),
            new SizedBox(
              height: 20.0,
            ),
            appButton(
                btnTxt: "Add Product",
                onBtnclicked: addNewProducts,
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  void changedDropDownCategory(String selectedSize) {
    setState(() {
      int index = categoryList.indexOf(selectedSize);
      if (categoryKey.length > 0)
        selectedCategory = categoryKey.elementAt(index);
    });
  }

  List<File> imageList;

  pickImage(bool picker) async {
    File file;
    if (!picker)
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    else
      file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      imageFile.add(file);
      //imageList = new List.from(imageFile);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
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

  removeImage(int index) async {
    //imagesMap.remove(index);
    imageList.removeAt(index);
    setState(() {});
  }

  addNewProducts() async {
    if (imageList == null || imageList.isEmpty) {
      showSnackBar("Product Images cannot be empty", scaffoldKey);
      return;
    }

    if (prodcutTitle.text == "") {
      showSnackBar("Product Title cannot be empty", scaffoldKey);
      return;
    }

    if (prodcutPrice.text == "") {
      showSnackBar("Product Price cannot be empty", scaffoldKey);
      return;
    }

    if (prodcutDesc.text == "") {
      showSnackBar("Product Description cannot be empty", scaffoldKey);
      return;
    }

    if (selectedCategory == "Select Product category") {
      showSnackBar("Please select a category", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    showSnackBar("Patienter le telechargement en cours...", scaffoldKey);
    String response = await appMethod.addProduct(
        atitre: prodcutTitle.text.toLowerCase().trim(),
        adescription: prodcutDesc.text.toLowerCase().trim(),
        aprix: double.parse(prodcutPrice.text.trim()),
        acategorie: selectedCategory,
        images: imageList);
    if (response == successful) {
      print("okay");
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (BuildContext context) => new MyHomePage()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }

  initialise() {
    imageList.clear();
    prodcutTitle.text = "";
    prodcutPrice.text = "";
    prodcutDesc.text = "";
    setState(() {});
  }
}
