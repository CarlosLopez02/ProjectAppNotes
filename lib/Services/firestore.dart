import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final CollectionReference notas = FirebaseFirestore.instance.collection('app-flutter');


  //CRUD
  //Create
  Future<void> addNote(String title, String content, String type){
    return notas.add({
      'timestamp': Timestamp.now(),
      'title': title,
      'content': content,
      'type': type,

    });
  }

  //Read
  Stream<QuerySnapshot> getNotasStream(){
    final notasStream = 
    notas.orderBy('timestamp',descending: true).snapshots();
    return notasStream;
  }

  //update
  Future<void> updateNote(String docId, String nuevoTitulo, String nuevoContenido, String newType){
    return notas.doc(docId).update({
     'title': nuevoTitulo,
     'content': nuevoContenido,
     'type': newType,
     'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNote(String docID) {
    return notas.doc(docID).delete();
  }

  

}