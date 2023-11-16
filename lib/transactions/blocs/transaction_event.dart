part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class TransactionFetched extends TransactionEvent {
  final bool isReload;
  TransactionFetched({
    this.isReload = false,
  });
}
