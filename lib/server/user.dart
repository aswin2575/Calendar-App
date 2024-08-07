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
  DateTime? get admissionYear => _admissionYear;
  set admissionYear(DateTime? value) {
    _admissionYear = value;
    if (value == null) return;
    final now = DateTime.now();
    final year = now.year - value.year;
    final oddSem = now.month > 6;
    _semester = Semester._(oddSem? year*2+1: (year+1)*2);
  }
  Semester? get semester => _semester;
  late bool isAdmin;

  late DateTime? _admissionYear;
  Semester? _semester;

  User._fromMap(Map<String, dynamic> data) {
    name = data['name']! as String;
    photoUrl = data['photoUrl']! as String;
    email = data['email']! as String;
    id = data['id']! as String;
    isAdmin = data['isAdmin']! as bool;
    department = data.containsKey('department')? Department(code: data['department']): null;
    admissionYear = data.containsKey('admissionYear')? DateTime.fromMillisecondsSinceEpoch(data['admissionYear']): null;
  }

  static Map<String, User> cache = {};
  static Future<User> load(String id) async {
    if (cache.containsKey(id)) return cache[id]!;

    final databaseRef = FirebaseFirestore.instance;
    final collection = databaseRef.collection('Users');

    final docRef = collection.doc(id);
    final snapshot = await docRef.get();
    final data = snapshot.data()!;

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

      _instance =
      User.cache[userDetails.uid] = _instance = AuthenticatedUser._fromMap(data);
      _instance!.followingEvents.addAll(await Future.wait((data['followingEvents']! as List<dynamic>).map((e) => Event.load(e))));
      _instance!.followingChannels.addAll(await Future.wait((data['followingChannels']! as List<dynamic>).map((e) => Channel.load(e))));
      _instance!.myEvents.addAll(await Future.wait((data['myEvents']! as List<dynamic>).map((e) => Event.load(e))));
      _instance!.myChannels.addAll(await Future.wait((data['myChannels']! as List<dynamic>).map((e) => Channel.load(e))));
    }

    return _instance;
  }
}