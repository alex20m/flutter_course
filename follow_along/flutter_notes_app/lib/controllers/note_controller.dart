import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../models/note.dart';

class NoteController extends GetxController {
  final userController = Get.find<UserController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var notes = <Note>[].obs;

  @override
  void onInit() async {
    super.onInit();

    if (userController.user.value == null) {
      return;
    }

    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: userController.user.value!.uid)
        .get();
    final notesList = snapshot.docs.map((doc) {
      return Note.fromFirestore(doc.data(), doc.id);
    }).toList();

    notes.value = notesList;
  }

  void addNote(String content) async {
    final noteData = Note(
      id: '',
      content: content,
      userId: userController.user.value!.uid,
    ).toFirestore();

    final noteRef = await _firestore.collection('notes').add(noteData);
    final note = Note.fromFirestore(noteData, noteRef.id);
    notes.add(note);
  }

  void deleteNoteById(String id) async {
    await _firestore.collection('notes').doc(id).delete();
    notes.removeWhere((note) => note.id == id);
  }
}