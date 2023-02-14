// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:otlob/screens/Auth/sign_up.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/utils/helpers.dart';
import 'package:otlob/value/constant.dart';

import 'model/app_model.dart';

class FirebaseFirestoreController with Helpers {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ///=================== Start app =====================///

  Future<Map<String, dynamic>?> getAppInfo() async {
    return await _firebaseFirestore
        .collection('const')
        .doc('llLTEFzGiPxQdaDd1wO3')
        .get()
        .then((value) async {
      if (value.exists) {
        log('getAppInfo firebase is ${value.data()}');
        return value.data()!;
      } else {
        log('false');
        getSheetError('false');

        return null;
      }
    }).catchError((onError) {
      log('ex getAppInfo ===>>>>> $onError');
      getSheetError(onError.toString());
      return null;
    });
  }

  Stream<List<AppModel>> appDataList() {
    return _firebaseFirestore.collection("const").snapshots().map((snapshot) {
      log('message***************');
      return snapshot.docs.map((e) {
        AppController.getAppData(AppModel.appModelSnapshot(e));
        AppController.appData.value = AppModel.appModelSnapshot(e);

        return AppModel.appModelSnapshot(e);
      }).toList();
    });
  }

  ///=================== end app =====================///

  ///=================== Start Auth =====================///

  Future<Map<String, dynamic>?> getUserDataFromFirestore(
      {required String uid}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) async {
      if (value.exists) {
        log('getUserDataFromFirestore true');
        UserModel userData = UserModel.fromMap(value.data()!);
        log('getUserDataFromFirestore true');
        Map<String, dynamic> data = userData.toMapSaveData(userData);
        log('getUserDataFromFirestore true');
        await AppPreferences().saveUserData(data);
        log('getUserDataFromFirestore true');
        return value.data()!;
      } else {
        log('false');
        SVProgressHUD.dismiss();

        return null;
      }
    }).catchError((onError) {
      log('ex getUserDataFromFirestore ===>>>>> $onError');
      SVProgressHUD.dismiss();

      return null;
    });
  }

  Future<bool> checkUserExists(uid) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    if (snap.exists) {
      log("EXISTING USER");
      return true;
    } else {
      log("NEW USER");
      // await saveDataToFirestore(uid);
      Get.to(const SignUpScreen());
      return false;
    }
  }

  Future<bool> addUserToFirestore({required UserModel userModel}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toMap())
        .then((value) => true)
        .catchError((error) {
      SVProgressHUD.dismiss();

      return false;
    });
  }

  Future<bool> updateFirestore(
      {required String doc,
      required String key,
      required var value,
      required String collectionName}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(doc)
        .update({key: value})
        .then((value) => true)
        .catchError((error) {
          log('updateFirestore $error');
          getSheetSucsses(error.toString());
          SVProgressHUD.dismiss();

          return false;
        });
  }

  Future<Map<String, dynamic>?> getUserUid({required String phone}) async {
    log("PHONE IS ==================>>> $phone");
    return await _firebaseFirestore
        .collection('users')
        .where("phone", isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs[0].data();
      } else {
        return null;
      }
    }).catchError((onError) {
      getSheetError(onError.toString());
      log(onError.toString());
      SVProgressHUD.dismiss();

      return null;
    });
  }

  Future<Map<String, dynamic>?> getUserbyemail({required String email}) async {
    log("EMAIL IS ==================>>> $email");
    return await _firebaseFirestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs[0].data();
      } else {
        return null;
      }
    }).catchError((onError) {
      getSheetError(onError.toString());
      log(onError.toString());
      SVProgressHUD.dismiss();

      return null;
    });
  }

  Future<bool> updatePassword({required String password, required uid}) async {
    return await _firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({"password": password})
        .then((value) => true)
        .catchError((onError) {
          getSheetError(onError.toString());
          log(onError.toString());
          SVProgressHUD.dismiss();

          return false;
        });
  }

  ///=================== end Auth =====================///

}
