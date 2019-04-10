import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soko/tools/app_methods.dart';
import 'app_data.dart';
import 'app_tools.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods implements AppMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<String> createUserAccount(
      {String unom, String umobile, String uusername, String upassword}) async {
    // TODO: implement createUserAccount
    String error;
    DocumentReference docRef;
    try {
      docRef = await firestore.collection(usersData).add({
        nom: unom,
        username: uusername,
        passwords: upassword,
        mobile: umobile
      });

      writeDataLocally(key: userID, value: docRef.documentID);
      writeDataLocally(key: nom, value: unom);
      writeDataLocally(key: username, value: uusername);
      writeDataLocally(key: passwords, value: upassword);
      writeDataLocally(key: mobile, value: umobile);
      writeDataLocally(key: avatare, value: null);
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  @override
  Future<String> logginUser({String username, String password}) async {
    // TODO: implement logginUser
    String error;
    try {
      await Firestore.instance
          .collection(usersData)
          .where("username", isEqualTo: username)
          .where("passwords", isEqualTo: password)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          writeDataLocally(key: userID, value: query.documents[0].documentID);
          writeDataLocally(key: nom, value: query.documents[0].data['nom']);
          writeDataLocally(
              key: username, value: query.documents[0].data['username']);
          writeDataLocally(
              key: password, value: query.documents[0].data['passwords']);
          writeDataLocally(
              key: mobile, value: query.documents[0].data['mobile']);
          writeDataLocally(
              key: avatare, value: query.documents[0].data['images']);
        } else {
          error = "nom d'utilisateur ou le mot de passe incorrect";
        }
      });
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> successfulMSG() async {
    return successful;
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  @override
  Future<bool> logOutUser() async {
    // TODO: implement logOutUser
    await clearDataLocally();

    return complete();
  }

  @override
  Future<DocumentSnapshot> getUserInfo(String userid) async {
    // TODO: implement getUserInfo
    return await firestore.collection(usersData).document(userid).get();
  }

  @override
  Future<String> addProduct(
      {String atitre,
      String adescription,
      double aprix,
      String acategorie,
      List<File> images}) async {
    // TODO: implement addProduct
    String error;
    DocumentReference docRef;
    List<String> _pathImages = new List();

    String id = await getStringDataLocally(key: userID);
    try {
      String _imagePath;
      List<dynamic> _pathImages = new List();
      StorageReference ref;
      StorageUploadTask _task = null;
      FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.signInAnonymously();

      for (File _img in images) {
        print("post start....");
        var dt = DateTime.now().millisecondsSinceEpoch.toString();
        ref = FirebaseStorage.instance
            .ref()
            .child("uploads/" + "img-" + dt + id + "-av.jpg");
        print("Image Reference ${ref.path}");
        _task = ref.putFile(_img);
        _task.onComplete.then((task) {
          print("upload tak is correct");
          task.ref.getDownloadURL().then((url) {
            _imagePath = url.toString();
            _pathImages.add({'image${_pathImages.length + 1}': _imagePath});
            if (_img == images.last) {
              _saveData(
                  atitre, adescription, aprix, acategorie, id, _pathImages);
            }
          });
        });
      }
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  void _saveData(String atitre, String adescription, double aprix,
      String acategorie, String id, List<dynamic> images) async {
    await Firestore.instance.collection(productCollection).add({
      titre: atitre,
      description: adescription,
      prix: aprix,
      categorie: acategorie,
      userID: id,
      image: images,
      likes: 0.0,
      create_at: DateTime.now()
    });
  }

  @override
  Future<List<List<String>>> getCategories() async {
    List<List<String>> list = new List();
    List<String> categories = new List();
    List<String> catKey = new List();
    try {
      await firestore
          .collection('categories')
          .orderBy("name", descending: false)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          for (DocumentSnapshot e in query.documents) {
            categories.add(e.data["name"]);
            catKey.add(e.documentID);
          }
        }
      });
    } on PlatformException catch (e) {
      //print(e.details);
      print(e.details);
    }
    list.add(categories);
    list.add(catKey);
    return list;
  }

  @override
  Future<Stream> getArticles() async {
    Stream data;
    try {
      Query query = firestore
          .collection('Articles')
          .orderBy("create_at", descending: true)
          .orderBy("titre", descending: false)
          .limit(100);

      // Map the documents to the data payload
      data = query.snapshots();
    } on PlatformException catch (e) {
      print(e);
    }
    // TODO: implement getArticles

    // Update the active tag
    return data;
  }

  @override
  Future<String> addLike({String artId}) async {
    String error = null;
    try {
      final DocumentReference docRef =
          await firestore.document("Articles/$artId");
      print(docRef.path);
      firestore.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(docRef);
        print("dound user id :${postSnapshot.documentID}");
        if (postSnapshot.exists) {
          print("User found run update");
          await tx.update(docRef, <String, dynamic>{
            likes: postSnapshot.data['likes'] + 1,
          });
        }
      });
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  @override
  Future<String> UpdateUserAccount(
      {String unom, String umobile, String upassword, File image}) async {
    // TODO: implement UpdateUserAccount
    String error;
    DocumentReference docRef;
    List<String> _pathImages = new List();

    String id = await getStringDataLocally(key: userID);
    try {
      String _imagePath;
      StorageReference ref;
      StorageUploadTask _task;
      FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.signInAnonymously();
      print("post start....");
      var dt = DateTime.now().millisecondsSinceEpoch.toString();
      ref = FirebaseStorage.instance
          .ref()
          .child("profiles/" + "img-" + dt + id + "-av.jpg");
      print("Image Reference ${ref.path}");
      _task = ref.putFile(image);
      _task.onComplete.then((task) {
        print("upload tak is correct");
        task.ref.getDownloadURL().then((url) {
          _imagePath = url.toString();
          //update infos
          updateUser(id, unom, umobile, upassword, _imagePath);
        });
      });
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  void updateUser(String id, String unom, String umobile, String upassword,
      String _imagePath) async {
    final DocumentReference docRef = await firestore.document("Comptes/$id");
    print(docRef.path);
    await firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(docRef);
      print("dound user id :${postSnapshot.documentID}");
      if (postSnapshot.exists) {
        print("User found run update");
        await tx.update(docRef, <String, dynamic>{
          nom: unom,
          mobile: umobile,
          passwords: upassword,
          avatare: _imagePath,
        });
      }
    });
    writeDataLocally(key: nom, value: unom);
    writeDataLocally(key: avatare, value: _imagePath);
    writeDataLocally(key: passwords, value: upassword);
    writeDataLocally(key: mobile, value: umobile);
  }

  @override
  Future<String> addToCart({String artID, double qte}) async {
    // TODO: implement addToCart
    String error;
    String id = await getStringDataLocally(key: userID);
    try {
      await Firestore.instance.collection(panierColletion).add({
        userID: id,
        produtID: artID,
        quantite: qte,
        create_at: DateTime.now()
      });
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }

    return error != null ? errorMSG(error) : successfulMSG();
  }

  @override
  Future<List> getCart() async {
    List<Map<String, dynamic>> articles = new List();
    Map<String, dynamic> value = Map();
    List<Map<String, dynamic>> keys = new List();
    Map<String, dynamic> item = Map();
    String artId;
    try {
      String id = await getStringDataLocally(key: userID);
      await firestore
          .collection('Panier')
          .where(userID, isEqualTo: id)
          .orderBy("create_at", descending: false)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          for (DocumentSnapshot e in query.documents) {
            item = Map();
            item['id'] = e.data[produtID];
            item[quantite] = e.data[quantite];
            item[create_at] = e.data[create_at];
            // Map<String, dynamic> map =await getVal(artId);
            keys.add(item);
          }
          print("before number of keys ${keys} \n\n\n\n\n");
        }
      });
      print("number of keys ${keys} \n\n");
      for (Map<String, dynamic> items in keys) {
        // print("Found product Id ${items['id']}");
        await firestore
            .document('Articles/${items['id']}')
            .get()
            .then((DocumentSnapshot doc) {
          value = Map();
          value[quantite] = items[quantite];
          value[create_at] = items[create_at];
          value[titre] = doc.data[titre];
          value[prix] = doc.data[prix];
          value[image] = doc.data[image];
          value[artId] = doc.documentID;
          articles.add(value);
        });
      }
    } on PlatformException catch (e) {
      //print(e.details);
      print(e.details);
    }
    return articles;
  }

  @override
  Future<String> deleteCart() async {
    String error;
    try {
      String id = await getStringDataLocally(key: userID);
      List<DocumentSnapshot> docs;
      await firestore
          .collection(panierColletion)
          .where(userID, isEqualTo: id)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          docs = query.documents;
        }
      });
      for (DocumentSnapshot doc in docs) {
        DocumentReference docRef =
            await firestore.document("$panierColletion/${doc.documentID}");
        print(docRef.path);
        firestore.runTransaction((Transaction tx) async {
          await tx.delete(docRef);
          print("Deleted document in db");
        });
      }
    } on PlatformException catch (e) {
      //print(e.details);
      error = "Une erreur s'est produite, veiller reesayer";
      print(e.details);
      return errorMSG(e.details);
    }
    return error != null ? errorMSG(error) : successfulMSG();
  }
}
