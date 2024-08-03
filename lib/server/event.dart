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
  // Channel? get channel { return _channel; }

  final List<String> tags = List<String>.empty(growable: true);
  final List<Link> links = List<Link>.empty(growable: true);
  final List<Contact> contacts = List<Contact>.empty(growable: true);

  Event( { required this.title, this.isInfo = false, this.description, this.location, this.scheduledDateTime, this.dueDateTime, this.imageUrl, this.channel } ) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    channel?.events.add(this);
  }

  Event._fromMap(Map<String, Object> data) {
    title = data['title'] as String;
    id = data['id'] as String;
    isInfo = data['isInfo'] as bool;
    description = data['description'] as String?;
    imageUrl = data['image'] as String?;
    location = data['location'] as String?;
    if (data.containsKey('scheduledDateTime')) scheduledDateTime = DateTime.fromMillisecondsSinceEpoch(data['scheduledDateTime'] as int);
    if (data.containsKey('dueDateTime')) dueDateTime = DateTime.fromMillisecondsSinceEpoch(data['dueDateTime'] as int);
    if (data.containsKey('tags')) tags.addAll(data['tags'] as List<String>);
    if (data.containsKey('links')) links.addAll((data['links'] as List<Map<String, String>>).map((e) => Link(e['title']!, e['uri']!)));
    if (data.containsKey('contacts')) contacts.addAll((data['contacts'] as List<Map<String, String>>).map((e) => Contact(e['name']!, e['phone']!)));
  }
  
  Future<bool> delete() async {
    channel?.events.remove(this);
    
    throw UnimplementedError();
  }

  static final Map<String, Event> _cache = {};
  static Future<Event> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    throw UnimplementedError();
    final data = <String, Object>{};

    final instance = _cache[id] = Event._fromMap(data);
    if (data.containsKey('channel')) instance.channel = await Channel.load(data['channel']! as String);
    return instance;
  }

  void commit() async {
    throw UnimplementedError();
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