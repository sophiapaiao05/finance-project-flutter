import 'package:finance_project_sophia_flutter/home/presentation/pages/chart/widgets/pie_chart.dart';
import 'package:finance_project_sophia_flutter/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_provider.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<void> _fetchTransactionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTransactionsFuture =
        Provider.of<TransactionProvider>(context, listen: false)
            .fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _fetchTransactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar transações.'));
          } else {
            return Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                if (transactionProvider.transactions.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma transação encontrada.'));
                } else {
                  return PieChartSample2(
                    transactions: transactionProvider.transactions,
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const PieChartSample2({super.key, required this.transactions});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: DynamicCard(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.3,
              top: MediaQuery.of(context).size.height * 0.1,
              left: AppSizes.marginLarge,
              right: AppSizes.marginLarge,
            ),
            child: TransactionsPieChart(
              transactions: widget.transactions,
            ),
          ),
        ),
      ],
    );
  }
}
