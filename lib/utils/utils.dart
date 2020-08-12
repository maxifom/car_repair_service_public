import 'package:car_repair_service/state/state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

clearController(TextEditingController c) => c.clear();

launchURL(url) async {
  if (await canLaunch(url)) {
    return await launch(url);
  }
  throw 'Launch $url failed';
}

saveUserInfo(UserInfo userInfo, DatabaseReference db) {
  db.child("users/${userInfo.userID}").set(userInfo.toJson());
}

// Сумма букв(ord) в строке
strToInt(String s) => s.runes.reduce((a, b) => a + b);
