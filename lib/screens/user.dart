import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stay_connected/models/GoogleAuthentication.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class Userview extends StatefulWidget {
  @override
  _UserviewState createState() => _UserviewState();
}

class _UserviewState extends State<Userview> {
  Map<String, dynamic> _profile;
  bool _loading = false;
  StreamSubscription streamSubscription, streamSubscription2;
  @override
  initState() {
    super.initState();
    streamSubscription =
        authService.profile.listen((state) => setState(() => _profile = state));
    streamSubscription2 =
        authService.loading.listen((state) => setState(() => _loading = state));
    //signin();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    streamSubscription2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginButton(),
            userProfile(context, _profile, _loading)
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialButton(
              onPressed: () => authService.googleSignout(),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Signout'),
            );
          } else {
            return MaterialButton(
              onPressed: () => authService.signInWithGoogle(),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Google'),
            );
          }
        });
  }
}

Widget userProfile(
    BuildContext buildContext, Map<String, dynamic> _profile, bool _loading) {
  return Column(children: <Widget>[
    Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
    Container(
        padding: EdgeInsets.all(20),
        child: Text('Loading: ${_loading.toString()}')),
  ]);
}
