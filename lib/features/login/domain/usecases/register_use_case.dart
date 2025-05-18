import 'package:finance_project_sophia_flutter/features/login/data/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserCredential> execute(String email, String password) {
    return repository.register(email, password);
  }
}
