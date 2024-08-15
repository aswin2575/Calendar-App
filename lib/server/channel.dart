part of 'server.dart';

class Channel {
  late final String id;
  late String name;
  String? description;
  late User owner;
  final List<String> _admins = List<String>.empty(growable: true);

  Future<List<User>> get admins async => await Future.wait(_admins.map((userid) => User.load(userid) as Future<User>));

  static final collection = FirebaseFirestore.instance.collection('Channels');

  Channel({ required this.name, required this.owner, this.description, String? id }) {
    this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  Channel._fromMap(Map<String, dynamic> data) {
    id = data['id']!;
    name = data['name']!;
    description = data['description'];
  }

  Future<void> commit() async {
    await collection.doc(id).set({
      'name': name,
      'id': id,
      'owner': owner.id,
      'description': description,
      'admin': _admins,
    });
  }

  Future<void> delete() async {
    await collection.doc(id).delete();
    _cache.remove(id);
  }

  static final Map<String, Channel> _cache = {};
  static Future<Channel?> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    final snapshot = await collection.doc(id).get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    final instance = _cache[id] = Channel._fromMap(data);
    instance.owner = (await User.load(data['owner']! as String))!;
    instance._admins.addAll((data['admin']! as List<dynamic>).map((e) => e as String));
    return instance;
  }

  static Future<List<Channel>> loadMultiple(Query<Map<String, dynamic>>? query) async {
    final snapshots = await query?.get() ?? await collection.get();
    final results = snapshots.docs.map((snapshot) async {
      final data = snapshot.data();
      final id = data['id']!;

      if (_cache.containsKey(id)) return _cache[id]!;

      final instance = _cache[id] = Channel._fromMap(data);
      instance.owner = (await User.load(data['owner']! as String))!;
      return instance;
    });

    return await Future.wait(results);
  }
}