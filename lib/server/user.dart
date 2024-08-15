part of 'server.dart';

class Department {
  final String name;
  final String code;

  static final Map<String, String> _departmentNames = {
    'CE': 'Civil Engineering',
    'ME': 'Mechanical Engineering',
    'EEE': 'Electrical and Electronics Engineering',
    'ECE': 'Electronics and Communication Engineering',
    'AE': 'Applied Electronics and Instrumentation Engineering',
    'CS': 'Computer Science and Engineering',
    'IT': 'Information Technology',
    'BT': 'Biotechnology Engineering',
    'CH': 'Chemical Engineering',
    'MT': 'Metallurgy and Materials Engineering',
    'PE': 'Production Engineering',
    'IC': 'Instrumentation and Control Engineering',
    'AU': 'Automobile Engineering',
    'EC': 'Electronics and Computer Engineering',
    'MR': 'Marine Engineering',
    'AI': 'Artificial Intelligence and Data Science',
  };

  static List<String> get codes => _departmentNames.keys.toList();

  Department({ name, required this.code }): name = name ?? _departmentNames.containsKey(code)? _departmentNames[code]!: 'Untitled Department';

  static Department get CE => Department(name: 'Civil Engineering', code: 'CE');
  static Department get ME => Department(name: 'Mechanical Engineering', code: 'ME');
  static Department get EEE => Department(name: 'Electrical and Electronics Engineering', code: 'EEE');
  static Department get ECE => Department(name: 'Electronics and Communication Engineering', code: 'ECE');
  static Department get AE => Department(name: 'Applied Electronics and Instrumentation Engineering', code: 'AE');
  static Department get CS => Department(name: 'Computer Science and Engineering', code: 'CSE');
  static Department get IT => Department(name: 'Information Technology', code: 'IT');
  static Department get BT => Department(name: 'Biotechnology Engineering', code: 'BT');
  static Department get CH => Department(name: 'Chemical Engineering', code: 'CH');
  static Department get MT => Department(name: 'Metallurgy and Materials Engineering', code: 'MT');
  static Department get PE => Department(name: 'Production Engineering', code: 'PE');
  static Department get IC => Department(name: 'Instrumentation and Control Engineering', code: 'IC');
  static Department get AU => Department(name: 'Automobile Engineering', code: 'AU');
  static Department get EC => Department(name: 'Electronics and Computer Engineering', code: 'EC');
  static Department get MR => Department(name: 'Marine Engineering', code: 'MR');
  static Department get AI => Department(name: 'Artificial Intelligence and Data Science', code: 'AI');
}

class Semester {
  final int _sem;

  Semester._(int sem): _sem = sem { assert(1 <= sem && sem <= 8); }

  Semester nextSem() => Semester._(_sem+1);
  Semester prevSem() => Semester._(_sem-1);

  @override
  String toString() => 'S$_sem';

  static Semester get S1 => Semester._(1);
  static Semester get S2 => Semester._(2);
  static Semester get S3 => Semester._(3);
  static Semester get S4 => Semester._(4);
  static Semester get S5 => Semester._(5);
  static Semester get S6 => Semester._(6);
  static Semester get S7 => Semester._(7);
  static Semester get S8 => Semester._(8);
}

class User {
  late String name, photoUrl, email, id;
  late Department? department;
  int? get admissionYear => _admissionYear;
  set admissionYear(int? value) {
    _admissionYear = value;
    if (value == null) return;
    final now = DateTime.now();
    final currentYear = now.year;
    final year = currentYear - value;
    final oddSem = now.month > 6;
    _semester = Semester._(oddSem? year*2+1: (year+1)*2);
  }
  Semester? get semester => _semester;
  late bool isAdmin;

  late int? _admissionYear;
  Semester? _semester;

  static final collection = FirebaseFirestore.instance.collection('Users');

  User._fromMap(Map<String, dynamic> data) {
    name = data['name']! as String;
    photoUrl = data['photoUrl']! as String;
    email = data['email']! as String;
    id = data['id']! as String;
    isAdmin = data['isAdmin']! as bool;
    department = data.containsKey('department')? Department(code: data['department']): null;
    admissionYear = data.containsKey('admissionYear')? data['admissionYear']: null;
  }

  static final Map<String, User> _cache = {};
  static Future<User?> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;

    final snapshot = await collection.doc(id).get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    final instance = _cache[id] = User._fromMap(data);
    return instance;
  }

  static Future<List<User>> loadMultiple(Query<Map<String, dynamic>>? query) async {
    final snapshots = await query?.get() ?? await collection.get();
    final results = snapshots.docs.map((snapshot) async {
      final data = snapshot.data();
      final id = data['id']!;

      if (_cache.containsKey(id)) return _cache[id]!;

      final instance = _cache[id] = User._fromMap(data);
      return instance;
    });

    return await Future.wait(results);
  }
}

class AuthenticatedUser extends User {
  final List<String> _followingEvents = List<String>.empty(growable: true);
  final List<String> _followingChannels = List<String>.empty(growable: true);
  // List<Event> myEvents = List<Event>.empty(growable: true);
  // List<Channel> myChannels = List<Channel>.empty(growable: true);

  Future<List<Event?>> get followingEvents async => await Future.wait(_followingEvents.map((eventId) => Event.load(eventId)));
  Future<List<Channel?>> get followingChannels async => await Future.wait(_followingChannels.map((channelId) => Channel.load(channelId)));
  Future<List<Event>> get myEvents async {
    final query = Event.collection.where('owner', isEqualTo: id).where('channel', isNull: true);
    return await Event.loadMultiple(query);
  }
  Future<List<Channel>> get myChannels async {
    final ownerQuery = Channel.collection.where('owner', isEqualTo: id);
    final adminQuery = Channel.collection.where('admin', arrayContains: id);
    final results = await Future.wait([ Channel.loadMultiple(ownerQuery), Channel.loadMultiple(adminQuery) ]);
    return results[0]+results[1];

  }

  AuthenticatedUser._fromMap(super.data): super._fromMap();

  void commit() async {
    await User.collection.doc(id).set({
      'name': name,
      'id': id,
      'photoUrl': photoUrl,
      'email': email,
      if (department != null) 'department': department!.code,
      if (admissionYear != null) 'admissionYear': admissionYear,
      'followingEvents': _followingEvents,
      'followingChannels': _followingChannels,
      'isAdmin': isAdmin
    });
  }

  static AuthenticatedUser? _instance;
  static Future<AuthenticatedUser?> get instance async {
    if (_instance == null) {
      final userDetails = FirebaseAuth.instance.currentUser;
      if (userDetails == null) return null;

      final docRef = User.collection.doc(userDetails.uid);
      final snapshot = await docRef.get();
      final data = snapshot.data();

      if (data == null) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        return null;
      }

      User._cache[userDetails.uid] = _instance = AuthenticatedUser._fromMap(data);
      _instance!._followingEvents.addAll((data['followingEvents']! as List<dynamic>).map((e) => e as String));
      _instance!._followingChannels.addAll((data['followingChannels']! as List<dynamic>).map((e) => e as String));
    }

    return _instance;
  }
}