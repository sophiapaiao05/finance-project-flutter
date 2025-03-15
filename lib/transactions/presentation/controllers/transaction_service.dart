import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TransactionModel>> fetchTransactions() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('transactions').get();

    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
