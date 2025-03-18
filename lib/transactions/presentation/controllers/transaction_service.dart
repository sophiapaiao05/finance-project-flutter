import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;

  Future<List<TransactionModel>> fetchTransactions({int limit = 10}) async {
    Query query =
        _firestore.collection('transactions').orderBy('date').limit(limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
    }

    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  void resetPagination() {
    _lastDocument = null;
  }
}
