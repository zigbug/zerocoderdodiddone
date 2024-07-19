import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  // Инициализация экземпляров Firebase Authentication и Google Sign-In
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Вход в Firebase с помощью email и пароля
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // Обработка ошибок при входе с помощью email и пароля
      print("Ошибка при входе с помощью email и пароля: $e");
      return null;
    }
  }

  // Метод для регистрации с помощью email и пароля
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Регистрация в Firebase с помощью email и пароля
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // Обработка ошибок при регистрации с помощью email и пароля
      print("Ошибка при регистрации с помощью email и пароля: $e");
      return null;
    }
  }

  // Метод для отправки запроса подтверждения почты
  Future<void> sendEmailVerification() async {
    try {
      // Получение текущего пользователя
      final user = _firebaseAuth.currentUser;

      // Отправка запроса подтверждения почты
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      // Обработка ошибок при отправке запроса подтверждения почты
      print("Ошибка при отправке запроса подтверждения почты: $e");
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    try {
      // Выход из Firebase и Google
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      // Обработка ошибок при выходе из системы
      print("Ошибка при выходе из системы: $e");
    }
  }

  // Получение текущего пользователя
  User? get currentUser => _firebaseAuth.currentUser;
}
