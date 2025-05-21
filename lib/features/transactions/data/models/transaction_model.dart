class TransactionModel {
  final String id;
  final String category;
  final double amount;
  final DateTime date;
  final String type;
  final String paymentMethod;
  final String description;

  TransactionModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.paymentMethod,
    required this.description,
  });

  // Factory para criar uma instância a partir de um documento do Firestore
  factory TransactionModel.fromFirestore(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['userId'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: DateTime.parse(data['date']),
      type: data['type'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'paymentMethod': paymentMethod,
    };
  }

  static List<TransactionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TransactionModel.fromFirestore(json))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(
      List<TransactionModel> transactions) {
    return transactions.map((transaction) => transaction.toMap()).toList();
  }
}
