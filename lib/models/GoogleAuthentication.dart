import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['https://www.googleapis.com/auth/userinfo.profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Shared State for Widgets
  Observable<FirebaseUser> user; // firebase user
  Observable<FirebaseUser> firebaseuser; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    firebaseuser = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> trySignInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signInSilently();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;

      // Step 3
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      updateUserData(user);

      // Done
      loading.add(false);
      print("signed in " + user.displayName);
      return user;
    } else {
      print("sign in ");
      return user = null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    // Start
    loading.add(true);

    // Step 1
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    // Step 3
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    updateUserData(user);
    // Done
    loading.add(false);
    print("signed in " + user.displayName);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<bool> googleSignout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    print("signed out ");
    return true;
  }
}

final AuthService authService = AuthService();
