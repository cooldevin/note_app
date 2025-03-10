import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'note_edit.dart';
import '../services/auth_service.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  String _selectedCategory = '全部';

  Color _getCategoryColor(String? category) {
    switch (category) {
      case '学习':
        return Colors.green;
      case '工作':
        return Colors.blue;
      case '生活':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserId = authService.currentUser?.id;

    // Set current user ID in provider
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    if (currentUserId != null) {
      noteProvider.setCurrentUser(currentUserId!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '我的笔记',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              dropdownColor: Colors.blue[800],
              iconEnabledColor: Colors.white,
              underline: Container(),
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(
                  value: '全部',
                  child: Text(
                    '全部',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: '学习',
                  child: Text(
                    '学习',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: '工作',
                  child: Text(
                    '工作',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: '生活',
                  child: Text(
                    '生活',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              if (currentUserId == null) return;
              
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(
                    userId: currentUserId,
                  ),
                ),
              );
              Provider.of<NoteProvider>(context, listen: false).loadNotes();
            },
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredNotes = _selectedCategory == '全部'
              ? noteProvider.notes
              : noteProvider.notes
                  .where((note) => note.category == _selectedCategory)
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(note.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          note.category ?? '未分类',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      note.content,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                    ),
                    onPressed: () async {
                      await noteProvider.deleteNote(note.id!);
                    },
                  ),
                  onTap: () async {
                    if (currentUserId == null) return;
                    
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditScreen(
                          note: note,
                          userId: currentUserId,
                        ),
                      ),
                    );
                    Provider.of<NoteProvider>(context, listen: false).loadNotes();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
