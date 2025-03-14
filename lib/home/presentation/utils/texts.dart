class AppTexts {
  static const String financeAnalysisTitle = 'Análises Financeiras';

  static String totalIncome(double totalIncome) =>
      'Renda Total: R\$${totalIncome.toStringAsFixed(2)}';

  static String totalExpense(double totalExpense) =>
      'Despesas Totais: R\$${totalExpense.toStringAsFixed(2)}';

  static String balance(double balance) =>
      'Saldo: R\$${balance.toStringAsFixed(2)}';

  static String chart = 'Gráfico';

  static String home = 'Home';

  static String transactions = 'Transações';
}
