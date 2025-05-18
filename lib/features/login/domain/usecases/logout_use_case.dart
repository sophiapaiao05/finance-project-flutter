import 'package:finance_project_sophia_flutter/features/login/data/repositories/login_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}
