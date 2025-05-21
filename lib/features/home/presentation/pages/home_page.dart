import 'package:finance_project_sophia_flutter/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/pages/chart/pie_chart.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/pages/finance_analysis/finance_analysis.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/pages/initial_page/initial_page.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/features/login/presentation/controllers/login_auth_provider.dart';
import 'package:finance_project_sophia_flutter/features/login/presentation/pages/login_page.dart';
import 'package:finance_project_sophia_flutter/features/transactions/presentation/pages/transactions_page.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildPageContent(0),
          const InitialPage(),
          TransactionsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.pie_chart),
            label: AppTexts.chart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppTexts.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monetization_on),
            label: AppTexts.transactions,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            if (transactionProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await Provider.of<LoginAuthProvider>(context,
                                listen: false)
                            .logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    DynamicCard(
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1,
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: AppSizes.marginLarge,
                        right: AppSizes.marginLarge,
                      ),
                      child: TransactionsPieChart(
                        transactions: transactionProvider.transactions,
                      ),
                    ),
                    FinancialAnalysisCard(
                        transactions: transactionProvider.transactions),
                  ],
                ),
              );
            }
          },
        );
      case 1:
        return const InitialPage();
      case 2:
        return TransactionsPage();
      default:
        return const Center(child: Text('Página Inicial'));
    }
  }
}
