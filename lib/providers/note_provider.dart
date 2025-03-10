import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];
  bool _isLoading = false;
  int? _currentUserId;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  void setCurrentUser(int userId) {
    _currentUserId = userId;
  }

  Future<void> loadNotes() async {
    if (_currentUserId == null) return;
    
    _isLoading = true;
    notifyListeners();

    _notes = await _noteService.getNotes(_currentUserId!);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content, String category) async {
    if (_currentUserId == null) return;
    
    await _noteService.createNote(
      title,
      content,
      category,
      _currentUserId!,
    );
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _noteService.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _noteService.deleteNote(id);
    await loadNotes();
  }

  Future<List<Note>> getNotesByCategory(String category) async {
    if (_currentUserId == null) return [];
    return await _noteService.getNotesByCategory(_currentUserId!, category);
  }
}
