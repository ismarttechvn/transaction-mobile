import 'package:flutter/material.dart';
import 'package:transactions/transactions/views/transaction_create_page.dart';

import '../widgets/transaction_list.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            'Giao dịch gần đây',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const TransactionsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionCreatePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
