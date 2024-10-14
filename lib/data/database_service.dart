import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference databaseReference;

  DatabaseService() : databaseReference = FirebaseDatabase.instance.ref();
}
