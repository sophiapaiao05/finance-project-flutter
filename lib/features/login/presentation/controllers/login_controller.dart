import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<String?> _errorMessage =
      BehaviorSubject<String?>.seeded(null);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String?> get errorMessageStream => _errorMessage.stream;

  LoginController(this._auth);

  Future<void> login(
      BuildContext context, String email, String password) async {
    _isLoading.add(true);
    _errorMessage.add(null);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Armazenar credenciais no cache
      await _storage.write(key: 'user', value: userCredential.user!.toString());

      // Navegar para a próxima página
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _errorMessage.add(_getErrorMessage(e.code));
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> register(
      BuildContext context, String email, String password) async {
    _isLoading.add(true);
    _errorMessage.add(null);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'password', value: password);

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _errorMessage.add(_getErrorMessage(e.code));
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> autoLogin(BuildContext context) async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (email != null && password != null) {
      await login(context, email, password);
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'O endereço de email está mal formatado.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este email.';
      case 'wrong-password':
        return 'A senha está incorreta.';
      case 'email-already-in-use':
        return 'O endereço de email já está em uso por outra conta.';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.';
      default:
        return 'Ocorreu um erro desconhecido. Por favor, tente novamente.';
    }
  }

  @override
  void dispose() {
    _isLoading.close();
    _errorMessage.close();
    super.dispose();
  }
}
