class Note {
  final String id;
  final String content;
  final String userId;

  Note({required this.id, required this.content, required this.userId});

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      content: data['content'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'userId': userId,
    };
  }
}