import 'package:finance_project_sophia_flutter/features/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:flutter/material.dart';

const textStyleDefault = TextStyle(
  color: Colors.white,
  fontSize: AppSizes.fontSizeMedium,
);

class FinancialAnalysisCard extends StatelessWidget {
  final List<TransactionModel> transactions;

  const FinancialAnalysisCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalIncome = transactions
        .where((transaction) => transaction.type == AppTexts.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    double totalExpense = transactions
        .where((transaction) => transaction.type == AppTexts.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    double balance = totalIncome - totalExpense;

    return DynamicCard(
      margin: const EdgeInsets.all(AppSizes.marginLarge),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppTexts.financeAnalysisTitle,
              style: TextStyle(
                fontSize: AppSizes.fontSizeLarge,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.marginMedium),
            Text(
              AppTexts.totalIncome(totalIncome),
              style: textStyleDefault,
            ),
            SizedBox(height: AppSizes.marginSmall),
            Text(
              AppTexts.totalExpense(totalExpense),
              style: textStyleDefault,
            ),
            SizedBox(height: AppSizes.marginSmall),
            Text(
              AppTexts.balance(balance),
              style: textStyleDefault,
            ),
          ],
        ),
      ),
    );
  }
}
