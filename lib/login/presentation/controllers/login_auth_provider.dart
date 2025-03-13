import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginAuthProvider();

  String? _errorMessage;
  UserCredential? _userCredential;
  User? _currentUser;

  String? get errorMessage => _errorMessage;
  bool get successLogin => _userCredential != null;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      _errorMessage = null;
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _userCredential = userCredential;
      _currentUser = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = getLoginErrorMessage(e.code);
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    try {
      _errorMessage = null;
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _userCredential = userCredential;
      _currentUser = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = getRegisterErrorMessage(e.code);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

String getLoginErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'invalid-email':
      return 'O endereço de email está mal formatado.';
    case 'user-disabled':
      return 'Este usuário foi desativado.';
    case 'user-not-found':
      return 'Nenhum usuário encontrado com este email.';
    case 'wrong-password':
      return 'A senha está incorreta.';
    default:
      return 'Ocorreu um erro desconhecido. Por favor, tente novamente.';
  }
}

String getRegisterErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'email-already-in-use':
      return 'O endereço de email já está em uso por outra conta.';
    case 'invalid-email':
      return 'O endereço de email está mal formatado.';
    case 'operation-not-allowed':
      return 'O cadastro de usuários com email e senha está desativado.';
    case 'weak-password':
      return 'A senha fornecida é muito fraca.';
    default:
      return 'Ocorreu um erro desconhecido. Por favor, tente novamente.';
  }
}
