library server;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

part 'channel.dart';
part 'user.dart';
part 'event.dart';

class Server {
  bool _initialized = false;
  AuthenticatedUser? _currentUser;

  AuthenticatedUser? get currentUser { return _currentUser; }
  bool get initialized { return _initialized; }

  Server._();

  static Future<void> initialize() async {
    if (_instance != null) return;
    _instance = Server._();
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
    _instance!._currentUser = await AuthenticatedUser.instance;
    _instance!._initialized = true;
  }

  static Server? _instance;
  static Server? get instance { return _instance; }

  Future<bool> signIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return false;

    print('Google Account Selected');
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
    final userDetails = userCred.user!;

    print('Firebase User Account Retrieved');

    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Users');

    final docRef = collection.doc(userDetails.uid);
    final snapshot = await docRef.get();

    print('Database Fetch Complete');

    final userData = snapshot.exists? snapshot.data()!: {
      'name': userDetails.displayName!,
      'email': userDetails.email!,
      'photoUrl': userDetails.photoURL!,
      'id': userDetails.uid,
      'followingEvents': [],
      'followingChannels': [],
      'myEvents': [],
      'myChannels': []
    };

    if (!snapshot.exists) collection.doc(userDetails.uid).set(userData);
    _currentUser = User.cache[userDetails.uid] = AuthenticatedUser._fromMap(userData);
    _currentUser!.followingEvents.addAll(await Future.wait((userData['followingEvents']! as List<dynamic>).map((e) => Event.load(e))));
    _currentUser!.followingChannels.addAll(await Future.wait((userData['followingChannels']! as List<dynamic>).map((e) => Channel.load(e))));
    _currentUser!.myEvents.addAll(await Future.wait((userData['myEvents']! as List<dynamic>).map((e) => Event.load(e))));
    _currentUser!.myChannels.addAll(await Future.wait((userData['myChannels']! as List<dynamic>).map((e) => Channel.load(e))));

    print('All Done');

    return true;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _currentUser = AuthenticatedUser._instance = null;
  }

  Future<List<Event>> getNewsFeeds() async {
    final random = Random(0);
    return List<Event>.generate(random.nextInt(30), (index) {
      var event = Event(
          title: 'Event $index',
          description: 'Some description $index',
          location: 'ADP LAB',
          scheduledDateTime: DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23))),
          imageUrl: random.nextBool()? 'https://fisat.ac.in/wp-content/uploads/2023/04/Nautilus.jpeg': null,
      );
      event.tags.addAll([ 'Arts', 'Sports' ]);
      event.links.addAll([ Link('Register', 'https://www.google.com') ]);
      event.contacts.addAll([ Contact('Ansif', '7025694703') ]);
      return event;
    });
  }
}