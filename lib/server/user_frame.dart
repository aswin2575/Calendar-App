part of 'server.dart';

class UserFrame {
  late final String email;
  late final Department? department;
  late final int? admissionYear;
  late final bool isAdmin;

  static final collection = FirebaseFirestore.instance.collection('UserFrames');

  UserFrame({required this.email, this.department, this.admissionYear, required this.isAdmin}) {
    collection.doc(email).set({
      'email': email,
      'isAdmin': isAdmin,
      'department': department?.code,
      'admissionYear': admissionYear,
    });
  }

  UserFrame._fromMap(Map<String, dynamic> data) {
    email = data['email']! as String;
    isAdmin = data['isAdmin']! as bool;
    department = data['department'] != null? Department(code: data['department']): null;
    admissionYear = data['admissionYear'];
  }

  Future<void> delete() async {
    await collection.doc(email).delete();
    _cache.remove(email);
  }

  static final Map<String, UserFrame> _cache = {};
  static Future<UserFrame?> load(String email) async {
    if (_cache.containsKey(email)) return _cache[email]!;

    final snapshot = await collection.doc(email).get();

    if (!snapshot.exists) return null;
    final data = snapshot.data()!;

    final instance = _cache[email] = UserFrame._fromMap(data);
    return instance;
  }

  static Future<List<UserFrame>> loadMultiple(Query<Map<String, dynamic>>? query) async {
    final snapshots = await query?.get() ?? await collection.get();
    final results = snapshots.docs.map((snapshot) async {
      final data = snapshot.data();
      final email = data['email']!;

      if (_cache.containsKey(email)) return _cache[email]!;

      final instance = _cache[email] = UserFrame._fromMap(data);
      return instance;
    });

    return await Future.wait(results);
  }
}