part of 'server.dart';

class Event {
  late final String id;
  late bool isInfo;
  late String title;
  late String? description;
  late String? imageUrl;
  late String? location;
  late DateTime? scheduledDateTime;
  late ActionLink? actionLink;
  late bool allDayEvent;

  late final Channel? channel;
  late final User owner;

  final List<String> tags = List<String>.empty(growable: true);
  final List<Link> links = List<Link>.empty(growable: true);
  final List<Contact> contacts = List<Contact>.empty(growable: true);

  static final collection = FirebaseFirestore.instance.collection('Events');

  Event({ required this.title, required this.owner, this.isInfo = false, this.description, this.location, this.scheduledDateTime, this.imageUrl, this.channel, this.actionLink, this.allDayEvent = true, String? id } ) {
    this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> commit() async {
    await collection.doc(id).set({
      'title': title,
      'id': id,
      'owner': owner.id,
      'isInfo': isInfo,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'scheduledDateTime': scheduledDateTime,
      'actionLink': actionLink == null? null: {
        'title': actionLink!.title,
        'uri': actionLink!.uri,
        'due': actionLink!.due,
      },
      'allDayEvent': allDayEvent,
      'tags': tags,
      'links': links.map((link) => { 'title': link.title, 'uri': link.uri }).toList(),
      'contacts': contacts.map((contact) => { 'name': contact.name, 'phone': contact.phone }).toList(),
      'channel': channel?.id,
    });
  }

  Event._fromMap(Map<String, dynamic> data) {
    title = data['title'];
    id = data['id'];
    isInfo = data['isInfo'];
    allDayEvent = data['allDayEvent'];
    description = data['description'];
    imageUrl = data['imageUrl'];
    location = data['location'];
    scheduledDateTime = (data['scheduledDateTime'] as Timestamp?)?.toDate();
    actionLink = data['actionLink'] != null? ActionLink._fromMap(data['actionLink']): null;
    tags.addAll((data['tags'] as List<dynamic>).map((e) => e as String));
    links.addAll((data['links'] as List<dynamic>).map((e) => Link(title: e['title']!, uri: e['uri']!)));
    contacts.addAll((data['contacts'] as List<dynamic>).map((e) => Contact(name: e['name']!, phone: e['phone']!)));
  }
  
  Future<void> delete() async {
    await collection.doc(id).delete();
    _cache.remove(id);
  }

  static final Map<String, Event> _cache = {};
  static Future<Event?> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    final snapshot = await collection.doc(id).get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    final instance = _cache[id] = Event._fromMap(data);
    instance.channel = data.containsKey('channel')? await Channel.load(data['channel']! as String): null;
    instance.owner = (await User.load(data['owner']! as String))!;
    return instance;
  }

  static Future<List<Event>> loadMultiple(Query<Map<String, dynamic>>? query) async {
    final snapshots = await query?.get() ?? await collection.get();
    final results = snapshots.docs.map((snapshot) async {
      final data = snapshot.data();
      final id = data['id']!;

      if (_cache.containsKey(id)) return _cache[id]!;

      final instance = _cache[id] = Event._fromMap(data);
      instance.channel = data['channel'] != null? await Channel.load(data['channel']): null;
      instance.owner = (await User.load(data['owner']! as String))!;
      return instance;
    });

    return await Future.wait(results);
  }
}

class Link {
  late String title;
  late String uri;

  Link({ required this.title, required this.uri });
}

class Contact {
  late String name;
  late String phone;

  Contact({ required this.name, required this.phone });
}

class ActionLink extends Link {
  late DateTime? due;

  ActionLink({required super.title, required super.uri, this.due});

  ActionLink._fromMap(Map<String, dynamic> data): super(title: data['title']! as String, uri: data['uri']! as String) {
    due = data.containsKey('due')? (data['due']! as Timestamp).toDate(): null;
  }
}