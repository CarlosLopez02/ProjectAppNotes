import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final CollectionReference notas = FirebaseFirestore.instance.collection('app-flutter');


  //CRUD
  //Create
  Future<void> addNote(String title, String content){
    return notas.add({
      'timestamp': Timestamp.now(),
      'title': title,
      'content': content,

    });
  }

}