import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    _transactions = await _transactionService.fetchTransactions();
    notifyListeners();
  }
}
