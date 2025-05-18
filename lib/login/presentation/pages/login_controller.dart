import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/pages/home_page.dart';

class LoginController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _errorMessage = null;

      // Navegação para a página inicial
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _errorMessage = null;

      // Navegação para a página inicial
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
    } finally {
      _isLoading = false;
      notifyListeners();
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
}
