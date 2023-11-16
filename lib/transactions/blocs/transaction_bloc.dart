import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:transactions/constants/api.dart';
import 'package:transactions/transactions/models/transaction.dart';
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../models/response.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

const _transactionLimit = 12;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({required this.httpClient})
      : super(const TransactionState()) {
    on<TransactionFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
      TransactionFetched event, Emitter<TransactionState> emit) async {
    if (state.hasReachedMax && !event.isReload) return;
    try {
      if (state.status == TransactionBlocStatus.initial || event.isReload) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: TransactionBlocStatus.success,
          transactions: posts.list,
          hasReachedMax: posts.hasReachedMax,
        ));
      }
      final posts = await _fetchPosts(
          (state.transactions.length / _transactionLimit).ceil());
      emit(posts.list.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: TransactionBlocStatus.success,
              transactions: List.of(state.transactions)..addAll(posts.list),
              hasReachedMax: posts.hasReachedMax,
            ));
    } catch (err) {
      print(err);
      emit(state.copyWith(status: TransactionBlocStatus.failure));
    }
  }

  Future<TransactionListResponse> _fetchPosts([int page = 0]) async {
    final response = await httpClient.get(
      Uri.http(
        apiUrl,
        transactionUrlPath,
        <String, String>{
          '__page': '$page',
          '__limit': '$_transactionLimit',
        },
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final res = Response.fromJson(body);
      final resData = ListResponse.fromJson(res.data);

      var list = resData.result.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Transaction.fromJson(map);
      }).toList();

      return TransactionListResponse(
        list: list,
        hasReachedMax: page * _transactionLimit + list.length == resData.total,
      );
    }
    throw Exception('error fetching posts');
  }
}
