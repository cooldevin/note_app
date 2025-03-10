import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'services/auth_service.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/note_list.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        Provider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/notes': (context) => const NoteListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/notes') {
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];
          final noteProvider = Provider.of<NoteProvider>(context, listen: false);
          noteProvider.setCurrentUser(userId);
        }
        return MaterialPageRoute(
          builder: (context) => const NoteListScreen(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
