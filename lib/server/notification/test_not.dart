import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FbHttpNotificationRequest {
  // List<String> listName = [
  //   "dDfXBJzNQXOkzOSi6RKgOe:APA91bHq6s1qMcqpwTF6itdksh15bzRauL6JosN5QxVc-ECdYuwCHp6NJD1G99EVN76OVIqph0P9w3hRy10yuLr2AoEJHO47Fb1VTdNaAk5ix_xZrSBllJjITyEqR9AzHuWiOJ7kn_MA",
  //   "dDfXBJzNQXOkzOSi6RKgOe:APA91bHq6s1qMcqpwTF6itdksh15bzRauL6JosN5QxVc-ECdYuwCHp6NJD1G99EVN76OVIqph0P9w3hRy10yuLr2AoEJHO47Fb1VTdNaAk5ix_xZrSBllJjITyEqR9AzHuWiOJ7kn_MA"
  // ];

  void sendNotification(
      String title, String body, List<dynamic> listName) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key =	AAAA5cDFWL0:APA91bH9k8b7HvoJ68G2WT5AGux5uPU9OoYxBSEaCP6gCl9UETp9_ZbRoiF7-FGzQUqKUGSr1Er738OwmYQBNajI6ufjQ6K342DJHoZz0LEHdQjwtse90wlH8KC4m2CPzfTzzSg0r-a3'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "notification": {
        "title": title,
        "body": body,
        "click_action": "OPEN_ACTIVITY_1"
      },
      "data": {"keyname": "any value "},
      "registration_ids": listName
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('111111111111111222222222222222222');
    } else {
      debugPrint(response.reasonPhrase);
    }
  }
}
