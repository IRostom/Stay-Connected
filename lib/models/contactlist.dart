import 'package:flutter/foundation.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';


class Contactlist extends ChangeNotifier {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _allContacts = new List<CustomContact>();
  List<CustomContact> _favContact = new List<CustomContact>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String name;

  Contactlist() {
    refreshContacts();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
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
        _contacts.map((contact) => CustomContact(contact: contact, primaryphone: contact.phones.first.value, displayname: contact.displayName)).toList();
  }

  Future<void> _scheduleNotification() async {
    DateTime scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        _favContact[_favContact.length - 1].id,
        'Reminder',
        'Stay connected with $name',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  List<CustomContact> get allcontacts => _allContacts;
  List<CustomContact> get favcontacts => _favContact;
}
