import 'package:finance_project_sophia_flutter/transactions/presentation/controllers/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_project_sophia_flutter/transactions/models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<TransactionModel> _filteredTransactions = [];
  String _selectedCategory = 'All';
  DateTime? _startDate;
  DateTime? _endDate;

  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get filteredTransactions => _filteredTransactions;
  String get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateTimeRange? _selectedDateRange;

  Future<void> fetchTransactions() async {
    _transactions = await TransactionService().fetchTransactions();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTransactions = _transactions.where((transaction) {
      if (_selectedCategory != 'All' &&
          transaction.category != _selectedCategory) {
        return false;
      }
      if (_selectedDateRange != null &&
          (transaction.date.isBefore(_selectedDateRange!.start) ||
              transaction.date.isAfter(_selectedDateRange!.end))) {
        return false;
      }
      return true;
    }).toList();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setDateRange(DateTime start, DateTime end) {
    _selectedDateRange = DateTimeRange(start: start, end: end);
    _applyFilters();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newTransaction = transaction;
    try {
      await _firestore
          .collection('transactions')
          .doc()
          .set(newTransaction.toMap());

      _transactions.add(newTransaction);
      _applyFilters();
    } catch (e) {
      print('Erro ao adicionar transação: $e');
    }
  }
}
