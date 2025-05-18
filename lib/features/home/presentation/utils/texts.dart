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

  static String transactionByApp = 'Transações por Aplicativo';

  static String balancePaymentMethod = 'Saldo';

  static String uploadReceipt = 'Enviar Recibo';

  static String uploadReceiptSubtitle =
      'Envie uma foto do seu recibo para registrar uma transação';

  static String noImageSelected = 'Nenhuma imagem selecionada.';

  static const String rentText = 'Pagamento de aluguel';

  static const String supermarketText = 'Compra no supermercado';

  static const String electronicsText = 'Compra de eletrônicos';

  static const String income = 'income';

  static const String expense = 'expense';
}
