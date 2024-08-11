part of 'server.dart';

class Channel {
  late final String id;
  late String name;
  String? description;
  late User owner;
  List<User> admins = List<User>.empty(growable: true);

  static final collection = FirebaseFirestore.instance.collection('Channels');

  Channel({ required this.name, required this.owner, this.description }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Channel._fromMap(Map<String, dynamic> data) {
    id = data['id']! as String;
    name = data['name']! as String;
    description = data['description'] as String?;
  }

  Future<void> commit() async {
    await collection.doc(id).set({
      'name': name,
      'id': id,
      'owner': owner.id,
      if (description != null) 'description': description!,
      'contacts': admins.map((admin) => admin.id).toList(),
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
    instance.admins.addAll(await Future.wait((data['admin']! as List<String>).map((e) async => (await User.load(e))!)));
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
      instance.admins.addAll(await Future.wait((data['admin']! as List<String>).map((e) async => (await User.load(e))!)));
      return instance;
    });

    return await Future.wait(results);
  }
}