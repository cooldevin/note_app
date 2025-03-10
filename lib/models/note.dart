class Note {
  int? id;
  String title;
  String content;
  String category;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.category = 'General',
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.userId,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  static final categories = ['General', 'Work', 'Study', 'Personal'];

  // Convert a Note into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  // Extract a Note from a Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }
}
