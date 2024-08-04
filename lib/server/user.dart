part of 'server.dart';

class User {
  late final String name, photoUrl, email, id;

  User._fromMap(Map<String, dynamic> data) {
    name = data['name']! as String;
    photoUrl = data['photoUrl']! as String;
    email = data['email']! as String;
    id = data['id']! as String;
  }

  static Map<String, User> cache = {};
  static Future<User> load(String id) async {
    if (cache.containsKey(id)) return cache[id]!;

    throw UnimplementedError();
    final data = <String, Object>{};

    final instance = cache[id] = User._fromMap(data);
    return instance;
  }
}

class AuthenticatedUser extends User {
  List<Event> followingEvents = List<Event>.empty(growable: true);
  List<Channel> followingChannels = List<Channel>.empty(growable: true);
  List<Event> myEvents = List<Event>.empty(growable: true);
  List<Channel> myChannels = List<Channel>.empty(growable: true);

  AuthenticatedUser._fromMap(super.data): super._fromMap();

  void commit() async {
    throw UnimplementedError();
  }

  static AuthenticatedUser? _instance;
  static Future<AuthenticatedUser?> get instance async {
    if (_instance == null) {
      final userDetails = FirebaseAuth.instance.currentUser;
      if (userDetails == null) return null;

      final databaseRef = FirebaseFirestore.instance;
      final collection = databaseRef.collection('Users');

      final docRef = collection.doc(userDetails.uid);
      final snapshot = await docRef.get();
      final data = snapshot.data()!;

      _instance = AuthenticatedUser._fromMap(data);
      User.cache[_instance!.id] = _instance!;
      _instance!.followingEvents.addAll(await Future.wait((data['followingEvents']! as List<dynamic>).map((e) => Event.load(e))));
      _instance!.followingChannels.addAll(await Future.wait((data['followingChannels']! as List<dynamic>).map((e) => Channel.load(e))));
      _instance!.myEvents.addAll(await Future.wait((data['myEvents']! as List<dynamic>).map((e) => Event.load(e))));
      _instance!.myChannels.addAll(await Future.wait((data['myChannels']! as List<dynamic>).map((e) => Channel.load(e))));
    }

    return _instance;
  }
}