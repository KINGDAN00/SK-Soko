import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppMethods {
  Future<String> logginUser({String username, String password});
  Future<String> createUserAccount(
      {String unom, String umobile, String uusername, String upassword});
  Future<String> UpdateUserAccount(
      {String unom,
      String umobile,
      String upassword,
      File image});
  Future<bool> logOutUser();
  Future<String> addProduct(
      {String atitre,
      String adescription,
      double aprix,
      String acategorie,
      List<File> images});
  Future<DocumentSnapshot> getUserInfo(String userid);
  Future<List<List<String>>> getCategories();
  Future<Stream> getArticles();
  Future<String> addLike({String artId});
  Future<List<dynamic>> getCart();
  Future<String> addToCart({String artID, double qte});
  Future<String> deleteCart();
}
