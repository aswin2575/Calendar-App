part of 'server.dart';

class User {
  late final String name, profile, email, id;

  User._fromMap(Map<String, Object> data) {
    name = data['name']! as String;
    profile = data['profile']! as String;
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

  Future<bool> signOut() async {
    throw UnimplementedError();
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
      final data = {
        'id': '123456789',
        'name': 'Ansif',
        'email': 'ansifmshamsu7025@gmail.com',
        'profile': 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740',
        'followingEvents': [],
        'followingChannels': [],
        'myEvents': [],
        'myChannels': []
      };

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