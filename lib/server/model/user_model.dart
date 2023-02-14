import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otlob/services/preferences/app_preferences.dart';

class UserModel {
  String uid = '';
  String phoneAuthUid = '';
  String emailAuthUid = '';
  int countOrder = 0;
  String name = '';
  String phone = '';
  String adderss = '';
  String city = '';
  String email = '';
  String provider = '';
  String fcm = '';
  String image = '';
  String userRate = 'مستخدم جديد';
  String paymentType = 'الدفع عند الاستلام';
  bool isActiveAccount = true;
  String password = '';
  bool isVerifyPhone = false;
  List myOrders = [];
  Map favorites = {'meals': [], 'restaurants': []};
  GeoPoint latLong = GeoPoint(
      double.parse(AppPreferences().getData(key: 'lat')),
      double.parse(AppPreferences().getData(key: 'long')));
  GeoPoint currentLocation = GeoPoint(
      double.parse(AppPreferences().getData(key: 'lat')),
      double.parse(AppPreferences().getData(key: 'long')));
  DateTime created = DateTime.now();
  DateTime lastSeen = DateTime.now();
  DateTime lastUpdate = DateTime.now();

  UserModel();

  UserModel.addUser(
      {required this.phoneAuthUid,
      required this.emailAuthUid,
      required this.name,
      required this.phone,
      required this.adderss,
      required this.city,
      required this.email,
      required this.provider,
      required this.fcm,
      required this.image,
      required this.password,
      required this.isVerifyPhone});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['uid'] = uid;
    map['phoneAuthUid'] = phoneAuthUid;
    map['emailAuthUid'] = emailAuthUid;
    map['countOrder'] = countOrder;
    map['name'] = name;
    map['phone'] = phone;
    map['adderss'] = adderss;
    map['city'] = city;
    map['email'] = email;
    map['provider'] = provider;
    map['fcm'] = fcm;
    map['image'] = image;
    map['userRate'] = userRate;
    map['paymentType'] = paymentType;
    map['isActiveAccount'] = isActiveAccount;
    map['password'] = password;
    map['isVerifyPhone'] = isVerifyPhone;
    map['latLong'] = latLong;
    map['currentLocation'] = currentLocation;
    map['created'] = created;
    map['lastSeen'] = lastSeen;
    map['lastUpdate'] = lastUpdate;
    map['myOrders'] = myOrders;
    map['favorites'] = favorites;
    map['created'] = DateTime.now();

    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    phoneAuthUid = map['phoneAuthUid'];
    emailAuthUid = map['emailAuthUid'];
    countOrder = map['countOrder'];
    adderss = map['adderss'];
    city = map['city'];
    provider = map['provider'];
    fcm = map['fcm'];
    image = map['image'];
    userRate = map['userRate'];
    paymentType = map['paymentType'];
    isActiveAccount = map['isActiveAccount'];
    password = map['password'];
    isVerifyPhone = map['isVerifyPhone'];
    latLong = map['latLong'];
    currentLocation = map['currentLocation'];
    created = map['created'].toDate();
    lastSeen = map['lastSeen'].toDate();
    lastUpdate = map['lastUpdate'].toDate();
  }

  Map<String, dynamic> toMapSaveData(UserModel user) {
    Map<String, dynamic> map = <String, dynamic>{};

    map['uid'] = user.uid;
    map['phoneAuthUid'] = user.phoneAuthUid;
    map['emailAuthUid'] = user.emailAuthUid;
    map['countOrder'] = user.countOrder;
    map['name'] = user.name;
    map['phone'] = user.phone;
    map['adderss'] = user.adderss;
    map['city'] = user.city;
    map['email'] = user.email;
    map['provider'] = user.provider;
    map['fcm'] = user.fcm;
    map['image'] = user.image;
    map['userRate'] = user.userRate;
    map['paymentType'] = user.paymentType;
    map['isActiveAccount'] = user.isActiveAccount;
    map['password'] = user.password;
    map['isVerifyPhone'] = user.isVerifyPhone;
    map['latLong'] = user.latLong.toString();
    map['currentLocation'] = user.currentLocation.toString();
    map['created'] = user.created.toString();
    map['lastSeen'] = user.lastSeen.toString();
    map['lastUpdate'] = user.lastUpdate.toString();
    map['myOrders'] = user.myOrders;
    map['favorites'] = user.favorites;
    return map;
  }
}
