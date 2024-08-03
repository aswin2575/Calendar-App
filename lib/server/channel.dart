part of 'server.dart';

class Channel {
  late final String id;
  late String name;
  String? description;
  late User owner;
  List<User> admins = List<User>.empty(growable: true);
  List<Event> events = List<Event>.empty(growable: true);

  Channel({ required this.name, required this.owner, this.description }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Channel._fromMap(Map<String, Object> data) {
    id = data['id']! as String;
    name = data['name']! as String;
    description = data['description'] as String?;
  }

  Future<bool> delete() async {
    throw UnimplementedError();
  }

  static final Map<String, Channel> _cache = {};
  static Future<Channel> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    throw UnimplementedError();
    final data = <String, Object>{};

    final instance = _cache[id] = Channel._fromMap(data);
    instance.owner = await User.load(data['owner']! as String);
    instance.admins.addAll(await Future.wait((data['admin']! as List<String>).map((e) => User.load(e))));
    instance.events.addAll(await Future.wait((data['events']! as List<String>).map((e) => Event.load(e))));
    return instance;
  }

  void commit() async {
    throw UnimplementedError();
  }
}