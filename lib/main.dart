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
    mocks();
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
          return const LoginPage();
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
      'userId': '3lkndaqqqf3',
      'description': 'Salário',
      'amount': 3000.0,
      'date': '2021-10-10',
      'type': 'income',
      'category': 'Salário',
      'paymentMethod': 'Transferencia Bancária',
    },
    {
      'userId': '3lkndaqqqf3',
      'description': 'Compra no supermercado',
      'amount': 50.0,
      'date': '2024-10-10',
      'type': 'expense',
      'category': 'Supermercado',
      'paymentMethod': 'Cartão de Crédito',
    },
    {
      'userId': '3lkrtfgcdf3',
      'description': 'Pagamento de aluguel',
      'amount': 500.0,
      'date': '2024-10-10',
      'type': 'expense',
      'category': 'Aluguel',
      'paymentMethod': 'Boleto',
    },
    {
      'userId': '3lkndxfcvdf3',
      'description': 'Compra de eletrônicos',
      'amount': 300.0,
      'date': '2024-10-10',
      'type': 'expense',
      'category': 'Eletrônicos',
      'paymentMethod': 'Cartão de Crédito',
    },
    {
      'userId': '3lkndaqqqf3',
      'description': 'Freelance',
      'amount': 800.0,
      'date': '2025-10-10',
      'type': 'income',
      'category': 'Freelance',
      'paymentMethod': 'Salario',
    },
  ];

  // Buscar todas as transações existentes de uma vez
  QuerySnapshot existingTransactionsSnapshot = await transactions.get();
  Map<String, Map<String, dynamic>> existingTransactionsMap = {};

  for (var doc in existingTransactionsSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    String key =
        '${data['userId']}_${data['description']}_${data['amount']}_${data['date']}';
    existingTransactionsMap[key] = data;
  }

  WriteBatch batch = FirebaseFirestore.instance.batch();

  for (var transaction in sampleTransactions) {
    String key =
        '${transaction['userId']}_${transaction['description']}_${transaction['amount']}_${transaction['date']}';

    if (!existingTransactionsMap.containsKey(key)) {
      DocumentReference docRef = transactions.doc();
      batch.set(docRef, transaction);
      print('Adicionando transação: $transaction');
    } else {
      print('Transação já existe: $transaction');
    }
  }

  try {
    await batch.commit().timeout(const Duration(seconds: 120));
    print('Transações adicionadas com sucesso');
  } catch (e) {
    print('Erro ao adicionar transações: $e');
  }
}
