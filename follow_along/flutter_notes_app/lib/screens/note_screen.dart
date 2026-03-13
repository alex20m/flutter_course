import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My notes'),
      ),
      body: Column(
        children: [
          AddNoteWidget(),
          Expanded(
            child: NoteListWidget(),
          ),
        ],
      ),
    );
  }
}

class AddNoteWidget extends StatelessWidget {
  AddNoteWidget({super.key});

  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    final textInputController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: textInputController,
          decoration: const InputDecoration(
            hintText: 'Enter note',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        TextButton(
          onPressed: () {
            if (textInputController.text.trim().isEmpty) return;

            noteController.addNote(textInputController.text);
            textInputController.clear();
          },
          child: const Text('Add note'),
        ),
      ],
    );
  }
}

class NoteListWidget extends StatelessWidget {
  NoteListWidget({super.key});

  final noteController = Get.find<NoteController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: noteController.notes.length,
        itemBuilder: (context, index) {
          final note = noteController.notes[index];
          return Card(
            child: ListTile(
              title: Text(note.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => noteController.deleteNoteById(note.id),
              ),
            ),
          );
        },
      ),
    );
  }
}