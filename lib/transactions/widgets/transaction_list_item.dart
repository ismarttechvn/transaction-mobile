import 'package:flutter/material.dart';
import 'package:transactions/transactions/views/transaction_detail_page.dart';
import 'package:transactions/utils/datetime_to_string.dart';

import '../models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailPage(
              transaction: transaction,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 80,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(transaction.payAt.toFormatString),
                Text(
                  "${transaction.costElement?.code ?? ""}: ${transaction.costElement?.name ?? ""}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${transaction.cost} VNĐ")
              ],
            )
          ],
        ),
      ),
    );
  }
}
