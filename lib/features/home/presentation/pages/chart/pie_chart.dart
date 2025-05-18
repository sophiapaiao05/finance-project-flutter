import 'package:finance_project_sophia_flutter/features/home/presentation/pages/chart/indicator.dart';
import 'package:finance_project_sophia_flutter/features/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/features/transactions/data/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionsPieChart extends StatefulWidget {
  final List<TransactionModel> transactions;

  const TransactionsPieChart({super.key, required this.transactions});

  @override
  State<StatefulWidget> createState() => TransactionsPieChartState();
}

class TransactionsPieChartState extends State<TransactionsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.transactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Indicator(
                  color: getColor(transaction.description),
                  text: transaction.description,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final totalAmount = widget.transactions
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
    return List.generate(widget.transactions.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final transaction = widget.transactions[i];
      final percentage = (transaction.amount / totalAmount) * 100;
      return PieChartSectionData(
        color: getColor(transaction.description),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  Color getColor(String description) {
    switch (description) {
      case AppTexts.rentText:
        return const Color(0xff0293ee);
      case AppTexts.supermarketText:
        return const Color(0xfff8b250);
      case AppTexts.electronicsText:
        return const Color(0xff845bef);
      default:
        return const Color(0xff13d38e);
    }
  }
}
