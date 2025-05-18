import 'package:finance_project_sophia_flutter/login/data/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserCredential> execute(String email, String password) {
    return repository.login(email, password);
  }
}
