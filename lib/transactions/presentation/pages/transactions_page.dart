import 'package:finance_project_sophia_flutter/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_provider.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
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
                    itemCount: transactionsProvider.transactions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == transactionsProvider.transactions.length) {
                        return SizedBox.shrink();
                      }
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
                          transaction.date.toIso8601String(),
                          style: textStyleDefault.copyWith(
                            fontSize: AppSizes.fontSizeSmall,
                          ),
                        ),
                        trailing: Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<TransactionProvider>(
                builder: (context, transactionsProvider, child) {
                  return DropdownButton<String>(
                    value: transactionsProvider.selectedCategory,
                    items: ['All', 'Food', 'Transport', 'Shopping']
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
              TextButton(
                onPressed: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    final transactionsProvider =
                        Provider.of<TransactionProvider>(context,
                            listen: false);
                    transactionsProvider.setDateRange(picked.start, picked.end);
                  }
                },
                child: Text('Selecionar Data'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
