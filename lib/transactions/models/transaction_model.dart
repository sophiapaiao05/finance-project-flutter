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

  factory TransactionModel.fromFirestore(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['userId'],
      category: data['category'],
      description: data['description'],
      amount: data['amount'],
      date: DateTime.parse(data['date']),
      type: data['type'],
      paymentMethod: data['paymentMethod'],
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
}
