import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:transactions/utils/datetime_to_string.dart';

import '../../constants/api.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  TransactionStatus status = TransactionStatus.waiting;

  @override
  void initState() {
    setState(() {
      status = widget.transaction.status;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Center(
          child: Text(
            'Chi tiết giao dịch',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.watch_later_outlined,
                  color: Colors.black,
                  size: 40,
                ),
                Expanded(child: Text(widget.transaction.payAt.toFormatString)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    status.toFormatString,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.book_rounded,
                  size: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "test",
                    //   style: const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    Text(
                      "${widget.transaction.costElement?.code ?? ""}: ${widget.transaction.costElement?.name ?? ""}",
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.money,
                  size: 40,
                ),
                Text("${widget.transaction.cost} VNĐ")
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.person_2_outlined,
                  size: 40,
                ),
                Text(
                    "${widget.transaction.costCenter?.code ?? ""} - ${widget.transaction.costCenter?.name ?? ""}"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 40,
                ),
                Text(widget.transaction.createdAt!.toFormatString)
              ],
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: status == TransactionStatus.waiting &&
                  DateTime.now().isBefore(widget.transaction.payAt),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    _cancel().then((value) {
                      setState(() {
                        status = TransactionStatus.cancelled;
                      });
                      context
                          .read<TransactionBloc>()
                          .add(TransactionFetched(isReload: true));
                    });
                  },
                  child: const Text('Huỷ'),
                ),
              ),
            ),
            Visibility(
              visible: status == TransactionStatus.waiting &&
                  DateTime.now().isAfter(widget.transaction.payAt),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    _approve().then((value) {
                      setState(() {
                        status = TransactionStatus.paid;
                      });
                      context
                          .read<TransactionBloc>()
                          .add(TransactionFetched(isReload: true));
                    });
                  },
                  child: const Text('Thanh toán'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancel() async {
    await http.put(
      Uri.http(
        apiUrl,
        "$transactionUrlPath/${widget.transaction.id}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "status": "cancelled",
      }),
    );
  }

  Future<void> _approve() async {
    await http.put(
      Uri.http(
        apiUrl,
        "$transactionUrlPath/${widget.transaction.id}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "status": "paid",
      }),
    );
  }
}
