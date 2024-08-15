library server;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

part 'channel.dart';
part 'user.dart';
part 'event.dart';
part 'user_frame.dart';

class Server {
  bool _initialized = false;
  AuthenticatedUser? _currentUser;
  late String? _appAdminId;

  AuthenticatedUser? get currentUser => _currentUser;
  String? get appAdminId => _appAdminId;
  bool get initialized { return _initialized; }

  Server._();

  static Future<void> initialize() async {
    if (_instance != null) return;
    _instance = Server._();
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
    final appAdminRef = FirebaseDatabase.instance.ref('admin');
    final appAdminSnapshot = await appAdminRef.get();
    _instance!._appAdminId = appAdminSnapshot.value as String?;
    _instance!._currentUser = await AuthenticatedUser.instance;
    _instance!._initialized = true;
  }

  static Server? _instance;
  static Server? get instance { return _instance; }

  Future<bool> signIn({ required BuildContext context, Widget Function(BuildContext, User)? signupBuilder, Widget Function(BuildContext)? signupErrorBuilder }) async {
    // Google Authentication
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;

    // Loading token and its id for credential creation
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Actual Firebase Authentication
    final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
    final userDetails = userCred.user!;

    // Setting up database connection
    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Users');

    // Fetching User details from Database
    final docRef = collection.doc(userDetails.uid);
    final snapshot = await docRef.get();

    // Loading userData if any or prepare template for new user
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

    // Moment where signup identifies
    if (!snapshot.exists) {
      // Need to check is this user the first signup to make him admin
      final appConfigDatabase = FirebaseDatabase.instance;
      final adminUidRef = appConfigDatabase.ref('admin');
      final adminUid = await adminUidRef.get();

      if (!adminUid.exists) {
        // The user is the first person joining the app, thereby he is the admin
        userData['isAdmin'] = true;

        if (!context.mounted) {
          await signOut();
          return false;
        }

        // If Signup Builder is available then launch as Admin
        final user = User._fromMap(userData);
        if (signupBuilder != null) {
          final route = MaterialPageRoute<bool>(builder: (context) => signupBuilder(context, user));
          final success = await Navigator.of(context).push<bool>(route) ?? false;

          if (!success) {
            await signOut();
            return false;
          }
        }

        // Create Necessary Default Channels
        List<Channel> channels = Department.codes.map((code) => Channel(
          id: code,
          name: Department._departmentNames[code]!,
          owner: user,
          description: '${Department._departmentNames[code]} Specific Channel'
        )).toList() + [
          Channel(
              id: 'asiet',
              name: 'ASIET',
              owner: user,
              description: 'The official main default channel'
          )
        ];

        await adminUidRef.set(userDetails.uid);
        await Future.wait(channels.map((channel) => channel.commit()));
      } else {
        // Else if check for whether the admin added user details in authorized list
        final userFrame = await UserFrame.load(userDetails.email!);

        if (!context.mounted) {
          await signOut();
          return false;
        }

        // If so Unauthorized
        if (userFrame == null) {
          if (signupErrorBuilder != null) Navigator.of(context).push<bool>(MaterialPageRoute(builder: (context) => signupErrorBuilder(context)));
          await signOut();
          return false;
        }

        userData['isAdmin'] = userFrame.isAdmin;
        if (userFrame.department != null) userData['department'] = userFrame.department!.code;
        if (userFrame.admissionYear != null) userData['admissionYear'] = userFrame.admissionYear!;

        if (!userFrame.isAdmin) {
          userData['followingChannels'] = [
            'asiet',
            userFrame.department!.code
          ];
        }

        // If signup Builder available launch it
        if (signupBuilder != null) {
          final route = MaterialPageRoute(builder: (context) => signupBuilder(context, User._fromMap(userData)));
          final success = await Navigator.of(context).push(route);

          if (!success) {
            await signOut();
            return false;
          }
        }

        await userFrame.delete();
      }

      collection.doc(userDetails.uid).set(userData);
    }

    _currentUser = await AuthenticatedUser.instance;
    return true;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _currentUser = AuthenticatedUser._instance = null;
  }

  Future<List<Event>> getNewsFeeds() async {
    // final random = Random(0);
    // return List<Event>.generate(random.nextInt(30), (index) {
    //   var event = Event._fromMap({
    //     'id': index.toString(),
    //     'title': 'Event $index',
    //     'isInfo': false,
    //     'description': 'Some description $index',
    //     'location': 'ADP LAB',
    //     'scheduledDateTime': DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23))),
    //     'actionLink': {
    //       'title': 'Register',
    //       'uri': 'https://www.google.com',
    //       'due': DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23)))
    //     },
    //     'allDayEvent': false,
    //     if (random.nextBool()) 'imageUrl':'https://fisat.ac.in/wp-content/uploads/2023/04/Nautilus.jpeg',
    //   });
    //   event.channel = null;
    //   event.tags.addAll([ 'Arts', 'Sports' ]);
    //   event.links.addAll([ Link(title: 'Google', uri: 'https://www.google.com') ]);
    //   event.contacts.addAll([ Contact(name: 'Ansif', phone: '7025694703') ]);
    //   return event;
    // });

    final query = Event.collection
        .where('channel', isNull: false)
        .where('scheduledDateTime', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('scheduledDateTime');

    return Event.loadMultiple(query);
  }
}