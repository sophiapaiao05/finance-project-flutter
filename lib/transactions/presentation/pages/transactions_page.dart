import 'package:finance_project_sophia_flutter/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const textStyleDefault = TextStyle(
  color: Colors.white,
  fontSize: AppSizes.fontSizeMedium,
);

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionsProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      transactionsProvider.fetchTransactions();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final transactionsProvider =
            Provider.of<TransactionProvider>(context, listen: false);
        transactionsProvider.fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinanceProjectColors.background,
      appBar: AppBar(
        backgroundColor: FinanceProjectColors.background,
        actions: [
          TextButton(
            onPressed: _showFilterDialog,
            child: Row(
              children: [
                Text(
                  'Filtros',
                  style: textStyleDefault.copyWith(
                    color: FinanceProjectColors.deepBlue,
                    fontSize: AppSizes.fontSizeSmall,
                  ),
                ),
                SizedBox(width: AppSizes.borderRadiusSmall),
                Container(
                  child: Icon(
                    Icons.filter_list,
                    color: FinanceProjectColors.deepBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: DynamicCard(
        child: Consumer<TransactionProvider>(
          builder: (context, transactionsProvider, child) {
            return Column(
              children: [
                Text(
                  TransactionTexts.title,
                  style: textStyleDefault.copyWith(
                    fontSize: AppSizes.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: transactionsProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          transactionsProvider.transactions[index];
                      return ListTile(
                        title: Text(
                          transaction.category,
                          style: TextStyle(
                            color: transaction.type == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        subtitle: Text(
                          formatDateToBrazilian(transaction.date),
                          style: textStyleDefault.copyWith(
                            fontSize: AppSizes.fontSizeSmall,
                          ),
                        ),
                        trailing: Text(
                          formatCurrencyToBRL(transaction.amount),
                          style: textStyleDefault.copyWith(
                            fontSize: AppSizes.fontSizeSmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FinanceProjectColors.background,
          title: Text('Filtros'),
          content: Consumer<TransactionProvider>(
            builder: (context, transactionsProvider, child) {
              return DropdownButton<String>(
                value: transactionsProvider.selectedCategory,
                items: [
                  'All',
                  'Salário',
                  'Supermercado',
                  'Aluguel',
                  'Eletrônicos',
                  'Freelance'
                ]
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  transactionsProvider.setCategory(value!);
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final transactionsProvider =
                    Provider.of<TransactionProvider>(context, listen: false);
                transactionsProvider
                    .fetchTransactions(); // Atualiza a lista de transações
                Navigator.of(context).pop();
              },
              child: Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }
}

String formatDateToBrazilian(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

String formatCurrencyToBRL(double amount) {
  final NumberFormat formatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return formatter.format(amount);
}
