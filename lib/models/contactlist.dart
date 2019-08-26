import 'package:flutter/foundation.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

class Contactlist extends ChangeNotifier {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _allContacts = new List<CustomContact>();
  List<CustomContact> _favContact = new List<CustomContact>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String name;

  Contactlist() {
    refreshContacts();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void addfav(CustomContact customContact) {
    if (customContact.isChecked) {
      _favContact.add(customContact);
      _favContact[_favContact.length - 1].id = _favContact.length - 1;
      _favContact[_favContact.length - 1].creation = DateTime.now();
      name = _favContact[_favContact.length - 1].contact.displayName;
      reminder() async {
        await _scheduleNotification();
      }
      reminder();
    } else {
      _favContact.remove(customContact);
      for (var i = 0; i < _favContact.length; i++) {
        _favContact[i].id = i;
      }
    }
    notifyListeners();
  }

  refreshContacts() async {
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    /* _uiCustomContacts = _allContacts
        .where((contact) => contact.isChecked == true)
        .toList(); */ //kant fl set state
  }

  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0',
        'Contacts Reminder',
        'Remind user to stay connected with contacts',
        icon: 'secondary_icon',
        sound: 'slow_spring_board',
        largeIcon: 'sample_large_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        _favContact[_favContact.length - 1].id,
        'This a reminder',
        'stay connected with $name',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  List<CustomContact> get allcontacts => _allContacts;
  List<CustomContact> get favcontacts => _favContact;
}
