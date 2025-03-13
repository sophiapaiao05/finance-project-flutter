import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_project_sophia_flutter/home/presentation/pages/home_page.dart';
import 'package:finance_project_sophia_flutter/login/presentation/controllers/login_auth_provider.dart';
import 'package:finance_project_sophia_flutter/login/presentation/pages/login_page.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProxyProvider<TransactionProvider, LoginAuthProvider>(
            create: (context) => LoginAuthProvider(),
            update: (context, transactionProvider, loginAuthProvider) =>
                LoginAuthProvider()),
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          /// return const LoginPage();
          return HomePage();
        }
      },
    );
  }
}

Future<void> mocks() async {
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');

  List<Map<String, dynamic>> sampleTransactions = [
    {
      'userId': '3lkndf3',
      'description': 'Compra no supermercado',
      'amount': 50.0,
      'date': '2021-10-10',
    },
    {
      'userId': '3lkndf3',
      'description': 'Pagamento de aluguel',
      'amount': 500.0,
      'date': '2021-10-10',
    },
    {
      'userId': '3lkndf3',
      'description': 'Compra de eletrônicos',
      'amount': 300.0,
      'date': '2021-10-10',
    },
  ];

  // Adicionar cada transação à coleção
  for (var transaction in sampleTransactions) {
    await transactions.add(transaction);
  }
}
