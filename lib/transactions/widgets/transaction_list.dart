import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/transaction_bloc.dart';
import 'bottom_loader.dart';
import 'transaction_list_item.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshData() async {
    context.read<TransactionBloc>().add(TransactionFetched(isReload: true));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          switch (state.status) {
            case TransactionBlocStatus.failure:
              return const Center(child: Text('Lỗi khi tải các giao dịch'));
            case TransactionBlocStatus.success:
              if (state.transactions.isEmpty) {
                return const Center(child: Text('Không có giao dịch nào'));
              }
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.transactions.length
                      ? const BottomLoader()
                      : TransactionListItem(
                          transaction: state.transactions[index]);
                },
                itemCount: state.hasReachedMax
                    ? state.transactions.length
                    : state.transactions.length + 1,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
              );
            case TransactionBlocStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TransactionBloc>().add(TransactionFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
