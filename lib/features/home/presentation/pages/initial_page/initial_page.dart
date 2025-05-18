import 'package:finance_project_sophia_flutter/features/home/presentation/pages/upload/upload_widget.dart';
import 'package:finance_project_sophia_flutter/transactions/presentation/pages/transactions_card.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinanceProjectColors.background,
      appBar: AppBar(
        backgroundColor: FinanceProjectColors.background,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReceiptUploadCard(),
              Transactions(),
            ],
          ),
        ),
      ),
    );
  }
}
