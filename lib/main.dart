import 'package:finance_project_sophia_flutter/features/home/presentation/pages/home_page.dart';
import 'package:finance_project_sophia_flutter/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:finance_project_sophia_flutter/login/presentation/controllers/login_auth_provider.dart';
import 'package:finance_project_sophia_flutter/login/presentation/pages/login_controller.dart';
import 'package:finance_project_sophia_flutter/login/presentation/pages/login_page.dart';
import 'package:finance_project_sophia_flutter/transactions/data/transactions_repository.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/utils/mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  final transactionsRepository = TransactionsRepository();
  await transactionsRepository.addMockTransactions(sampleTransactions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => LoginAuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginController()),
      ],
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
