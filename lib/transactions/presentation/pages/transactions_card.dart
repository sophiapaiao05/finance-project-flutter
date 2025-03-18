import 'package:finance_project_sophia_flutter/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_provider.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatefulWidget {
  final Function(TransactionModel) onSave;

  TransactionCard({required this.onSave});

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(TransactionModel(
        id: DateTime.now().toString(),
        description: _titleController.text,
        amount: double.parse(_amountController.text),
        date: DateTime.now(),
        type: AppTexts.transactionByApp,
        category: AppTexts.transactionByApp,
        paymentMethod: AppTexts.balancePaymentMethod,
      ));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSizes.paddingMedium,
          right: AppSizes.paddingMedium,
          left: AppSizes.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Título'),
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um título.';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um valor.';
                }
                if (double.tryParse(value) == null) {
                  return 'Por favor, insira um número válido.';
                }
                if (double.parse(value) <= 0) {
                  return 'Por favor, insira um valor maior que zero.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  'Salvar Transação',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FinanceProjectColors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Transactions extends StatelessWidget {
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionCard(onSave: (transaction) {
          final transactionProvider =
              Provider.of<TransactionProvider>(context, listen: false);
          transactionProvider.addTransaction(transaction);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicCard(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _startAddNewTransaction(context),
            child: Text('Adicionar Transação',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: FinanceProjectColors.orange,
            ),
          ),
          SizedBox(height: AppSizes.heightSmall),
        ],
      ),
    );
  }
}
