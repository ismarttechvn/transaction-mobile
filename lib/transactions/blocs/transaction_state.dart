part of 'transaction_bloc.dart';

enum TransactionBlocStatus { initial, success, failure }

final class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionBlocStatus.initial,
    this.transactions = const <Transaction>[],
    this.hasReachedMax = false,
  });

  final TransactionBlocStatus status;
  final List<Transaction> transactions;
  final bool hasReachedMax;

  TransactionState copyWith({
    TransactionBlocStatus? status,
    List<Transaction>? transactions,
    bool? hasReachedMax,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''TransactionState { status: $status, hasReachedMax: $hasReachedMax, transactions: ${transactions.length} }''';
  }

  @override
  List<Object> get props => [status, transactions, hasReachedMax];
}
