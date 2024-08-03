library server;

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';

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

  Future<List<Event>> getNewsFeeds() async {
    return List<Event>.generate(Random(5).nextInt(30), (index) {
      var event = Event(
          title: 'Event $index',
          description: 'Some description $index',
          location: 'ADP LAB',
          scheduledDateTime: DateTime(2024, 8, 10, 9),
          imageUrl: 'https://fisat.ac.in/wp-content/uploads/2023/04/Nautilus.jpeg',
      );
      event.tags.addAll([ 'Arts', 'Sports' ]);
      event.links.addAll([ Link('Register', 'https://www.google.com') ]);
      event.contacts.addAll([ Contact('Ansif', '7025694703') ]);
      return event;
    });
  }
}