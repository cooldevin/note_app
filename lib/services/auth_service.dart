import 'package:note_app/database/database_helper.dart';
import 'package:note_app/models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  factory AuthService() {
    return _instance;
  }

  User? _currentUser;
  
  User? get currentUser => _currentUser;

  AuthService._internal();

  Future<void> loginWithEmail(String email, String password) async {
    final user = await _dbHelper.getUserByEmail(email);
    if (user == null) {
      throw Exception('用户不存在');
    }
    if (user.password != password) {
      throw Exception('密码错误');
    }
    _currentUser = user;
  }

  Future<void> register(String email, String password) async {
    final existingUser = await _dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('邮箱已被注册');
    }
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch,
      email: email,
      password: password,
    );
    
    await _dbHelper.insertUser(user);
  }
}
