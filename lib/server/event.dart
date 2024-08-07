part of 'server.dart';

class Event {
  late final String id;
  late bool isInfo;
  late String title;
  String? description;
  String? imageUrl;
  String? location;
  DateTime? scheduledDateTime;
  DateTime? dueDateTime;

  late final Channel? channel;

  final List<String> tags = List<String>.empty(growable: true);
  final List<Link> links = List<Link>.empty(growable: true);
  final List<Contact> contacts = List<Contact>.empty(growable: true);

  Event( { required this.title, this.isInfo = false, this.description, this.location, this.scheduledDateTime, this.dueDateTime, this.imageUrl, this.channel } ) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    
    commit();
  }

  Future<void> commit() async {
    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Events');

    await collection.doc(id).set({
      'title': title,
      'id': id,
      'isInfo': isInfo,
      if (description != null) 'description': description!,
      if (location != null) 'location': location!,
      if (imageUrl != null) 'imageUrl': imageUrl!,
      if (scheduledDateTime != null) 'scheduledDateTime': scheduledDateTime!,
      if (dueDateTime != null) 'dueDateTime': dueDateTime!,
      'tags': tags,
      'links': links.map((link) => { 'title': link.title, 'uri': link.uri }).toList(),
      'contacts': contacts.map((contact) => { 'name': contact.name, 'phone': contact.phone }).toList(),
      if (channel != null) 'channel': channel!.id,
    });
  }

  Event._fromMap(Map<String, dynamic> data) {
    title = data['title'] as String;
    id = data['id'] as String;
    isInfo = data['isInfo'] as bool;
    if (data.containsKey('description')) description = data['description'] as String;
    if (data.containsKey('imageUrl')) imageUrl = data['imageUrl'] as String;
    if (data.containsKey('location')) location = data['location'] as String;
    if (data.containsKey('scheduledDateTime')) scheduledDateTime = DateTime.fromMillisecondsSinceEpoch(data['scheduledDateTime'] as int);
    if (data.containsKey('dueDateTime')) dueDateTime = DateTime.fromMillisecondsSinceEpoch(data['dueDateTime'] as int);
    if (data.containsKey('tags')) tags.addAll(data['tags'] as List<String>);
    if (data.containsKey('links')) links.addAll((data['links'] as List<Map<String, String>>).map((e) => Link(e['title']!, e['uri']!)));
    if (data.containsKey('contacts')) contacts.addAll((data['contacts'] as List<Map<String, String>>).map((e) => Contact(e['name']!, e['phone']!)));
  }
  
  Future<void> delete() async {
    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Events');
    
    await collection.doc(id).delete();
  }

  static final Map<String, Event> _cache = {};
  static Future<Event> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Events');
    
    final snapshot = await collection.doc(id).get();
    final data = snapshot.data()!;

    final instance = _cache[id] = Event._fromMap(data);
    if (data.containsKey('channel')) instance.channel = await Channel.load(data['channel']! as String);
    return instance;
  }
}

class Link {
  String title;
  String uri;

  Link(this.title, this.uri);
}

class Contact {
  String name;
  String phone;

  Contact(this.name, this.phone);
}