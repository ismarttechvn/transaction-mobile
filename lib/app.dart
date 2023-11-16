import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions/transactions/views/transaction_list_page.dart';

import 'transactions/blocs/transaction_bloc.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionBloc(httpClient: http.Client())..add(TransactionFetched()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TransactionListPage(),
      ),
    );
  }
}
