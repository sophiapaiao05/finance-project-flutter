import 'package:finance_project_sophia_flutter/home/presentation/pages/chart/widgets/pie_chart.dart';
import 'package:finance_project_sophia_flutter/home/presentation/pages/finance_analysis/finance_analysis.dart';
import 'package:finance_project_sophia_flutter/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_provider.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/pages/transactions_page.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _logoPath = 'lib/utils/images/logo.svg';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false)
        .fetchTransactions();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: FinanceProjectColors.deepBlue,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SvgPicture.asset(
                _logoPath,
                height: 40,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: FinanceProjectColors.background,
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildPageContent(
                _selectedIndex, transactionProvider.transactions);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: AppTexts.chart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppTexts.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: AppTexts.transactions,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPageContent(int index, List<TransactionModel> transactions) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DynamicCard(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: AppSizes.marginLarge,
                  right: AppSizes.marginLarge,
                ),
                child: TransactionsPieChart(
                  transactions: transactions,
                ),
              ),
              FinancialAnalysisCard(transactions: transactions),
            ],
          ),
        );
      case 1:
        return const Center(child: Text('Página Inicial'));
      case 2:
        return TransactionsPage();
      default:
        return const Center(child: Text('Página Inicial'));
    }
  }
}
