import '../database/database_helper.dart';
import '../models/note.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Note>> getNotes(int userId) async {
    return await _dbHelper.getNotes(userId);
  }

  Future<int> addNote(Note note) async {
    return await _dbHelper.insertNote(note);
  }

  Future<int> updateNote(Note note) async {
    return await _dbHelper.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _dbHelper.deleteNote(id);
  }

  Future<List<Note>> getNotesByCategory(int userId, String category) async {
    final notes = await _dbHelper.getNotes(userId);
    return notes.where((note) => note.category == category).toList();
  }
}
