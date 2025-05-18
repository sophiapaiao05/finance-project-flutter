import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsRepository {
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');

  Future<void> addMockTransactions(
      List<Map<String, dynamic>> sampleTransactions) async {
    QuerySnapshot existingTransactionsSnapshot = await _transactions.get();
    Map<String, Map<String, dynamic>> existingTransactionsMap = {};

    for (var doc in existingTransactionsSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String key =
          '${data['userId']}_${data['description']}_${data['amount']}_${data['date']}';
      existingTransactionsMap[key] = data;
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var transaction in sampleTransactions) {
      String key =
          '${transaction['userId']}_${transaction['description']}_${transaction['amount']}_${transaction['date']}';

      if (!existingTransactionsMap.containsKey(key)) {
        DocumentReference docRef = _transactions.doc();
        batch.set(docRef, transaction);
        print('Adicionando transação: $transaction');
      } else {
        print('Transação já existe: $transaction');
      }
    }

    try {
      await batch.commit().timeout(const Duration(seconds: 120));
      print('Transações adicionadas com sucesso');
    } catch (e) {
      print('Erro ao adicionar transações: $e');
    }
  }
}
