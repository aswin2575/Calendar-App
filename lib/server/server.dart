library server;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<bool> signIn(BuildContext context, { Widget Function(BuildContext)? signupBuilder }) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
    final userDetails = userCred.user!;

    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Users');

    final docRef = collection.doc(userDetails.uid);
    final snapshot = await docRef.get();

    final userData = snapshot.exists? snapshot.data()!: {
      'name': userDetails.displayName!,
      'email': userDetails.email!,
      'photoUrl': userDetails.photoURL!,
      'id': userDetails.uid,
      'isAdmin': false,
      'followingEvents': [],
      'followingChannels': [],
      'myEvents': [],
      'myChannels': []
    };

    if (!snapshot.exists) {
      final snapshot = await collection.count().get();
      final userCount = snapshot.count;
      if (userCount == 0) userData['isAdmin'] = true;
      collection.doc(userDetails.uid).set(userData);
    }
    _currentUser = await AuthenticatedUser.instance;

    if (!context.mounted) {
      await signOut();
      return false;
    }

    if (signupBuilder != null) {
      final route = MaterialPageRoute<bool>(builder: signupBuilder);
      final success = await Navigator.of(context).push<bool>(route) ?? false;

      if (!success)  {
        await signOut();
        return false;
      }
    }

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
      var event = Event._fromMap({
        'id': index.toString(),
        'title': 'Event $index',
        'isInfo': false,
        'description': 'Some description $index',
        'location': 'ADP LAB',
        'scheduledDateTime': DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23))).millisecondsSinceEpoch,
        'actionLink': {
          'title': 'Register',
          'uri': 'https://www.google.com',
          'due': DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23))).millisecondsSinceEpoch
        },
        'allDayEvent': false,
        if (random.nextBool()) 'imageUrl':'https://fisat.ac.in/wp-content/uploads/2023/04/Nautilus.jpeg',
      });
      event.channel = null;
      event.tags.addAll([ 'Arts', 'Sports' ]);
      event.links.addAll([ Link(title: 'Google', uri: 'https://www.google.com') ]);
      event.contacts.addAll([ Contact(name: 'Ansif', phone: '7025694703') ]);
      return event;
    });
  }
}