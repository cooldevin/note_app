import '../repositories/note_repository.dart';
import '../models/note.dart';

class NoteService {
  final NoteRepository _noteRepository = NoteRepository();

  Future<List<Note>> getNotes(int userId) async {
    return await _noteRepository.getNotes(userId);
  }

  Future<int> createNote(String title, String content, String category, int userId) async {
    final note = Note(
      title: title,
      content: content,
      category: category,
      userId: userId,
    );
    return await _noteRepository.addNote(note);
  }

  Future<int> updateNote(Note note) async {
    return await _noteRepository.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _noteRepository.deleteNote(id);
  }

  Future<List<Note>> getNotesByCategory(int userId, String category) async {
    return await _noteRepository.getNotesByCategory(userId, category);
  }
}
