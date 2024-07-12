import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Вход с помощью электронной почты и пароля
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Ошибка входа: ${e.toString()}');
      rethrow; // Перебросить для обработки ошибок на более высоком уровне
    }
  }

  // Регистрация с помощью электронной почты и пароля
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    // Проверка валидности email
    if (!isValidEmail(email)) {
      throw Exception('Неверный формат электронной почты');
    }

    try {
      // Создать пользователя
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Отправить письмо с подтверждением
      await credential.user!.sendEmailVerification();

      return credential;
    } catch (e) {
      print('Ошибка регистрации: ${e.toString()}');
      rethrow;
    }
  }

  // Отправка письма с подтверждением (отдельный метод)
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print('Ошибка отправки письма с подтверждением: ${e.toString()}');
      rethrow;
    }
  }

  // Вход с помощью Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Ошибка входа с помощью Google: ${e.toString()}');
      rethrow;
    }
  }

  // Выход
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Ошибка выхода: ${e.toString()}');
      rethrow;
    }
  }

  // Получить текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Поток для состояния аутентификации пользователя
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Проверка валидности email
  bool isValidEmail(String email) {
    // Простая проверка, можно использовать более сложные регулярные выражения
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
        .hasMatch(email);
  }
}
