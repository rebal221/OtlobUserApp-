// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String path) async {
    var uuid = const Uuid();
    String name = '$path/${uuid.v4()}';
    var image = _firebaseStorage.ref(name);
    await image.putFile(file).then((p0) => true).catchError((onError) {
      debugPrint('ex upload is $onError');
      return false;
    });
    return await image.getDownloadURL();
  }

  Future<String> uploadImagee(File file, String path) async {
    var uuid = const Uuid();
    String name = '$path/${uuid.v4()}';
    var image = _firebaseStorage.ref(name);
    await image.putFile(file);
    return await image.getDownloadURL();
  }
}
