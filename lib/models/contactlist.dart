import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:stay_connected/models/customcontact.dart';
import 'package:flutter/foundation.dart';

class Contactlist extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Contactlist() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /* void addreminder(CustomContact customContact) {
    _scheduleNotification();
    notifyListeners();
  } */

  /* Future<void> _scheduleNotification(int interval, int contactid, String displayname) async {
    DateTime scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'stay connected channel id',
        'stay connected',
        'Reminders to stay connected with your contacts');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformsChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        contactid,
        'Reminder',
        'Stay connected with $displayname',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  } */

  /* reminder() async {
    await _scheduleNotification();
  } */
}
