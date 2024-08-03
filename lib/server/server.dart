library server;

import 'dart:math';

part 'channel.dart';
part 'user.dart';
part 'event.dart';

class Server {
  bool _initialized = false;
  AuthenticatedUser? _currentUser;

  AuthenticatedUser? get currentUser { return _currentUser; }
  bool get initialized { return _initialized; }

  Server._();

  Future<bool> initialize() async {
    _currentUser = await AuthenticatedUser.instance;
    return true;
  }

  static Server? _instance;
  static Server get instance {
    _instance ??= Server._();
    return _instance!;
  }

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