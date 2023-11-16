import 'package:equatable/equatable.dart';
import 'package:transactions/transactions/models/payment_method.dart';

import 'cost_center.dart';
import 'cost_element.dart';

enum TransactionStatus {
  waiting,
  paid,
  cancelled,
}

extension TransactionStatusExtension on TransactionStatus {
  String get toFormatString {
    switch (this) {
      case TransactionStatus.waiting:
        return 'Chờ thanh toán';
      case TransactionStatus.paid:
        return 'Đã thanh toán';
      case TransactionStatus.cancelled:
        return 'Đã huỷ';
      default:
        return 'Unknown';
    }
  }
}

TransactionStatus convertStringToTransactionStatus(String statusString) {
  switch (statusString) {
    case 'waiting':
      return TransactionStatus.waiting;
    case 'paid':
      return TransactionStatus.paid;
    case 'cancelled':
      return TransactionStatus.cancelled;
    default:
      throw ArgumentError('Invalid status string: $statusString');
  }
}

final class Transaction extends Equatable {
  const Transaction({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.cost,
    required this.costCenterId,
    this.costCenter,
    required this.payAt,
    required this.costElementId,
    this.costElement,
    required this.content,
    required this.paymentMethodId,
    this.paymentMethod,
    required this.status,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int cost;
  final int costCenterId;
  final CostCenter? costCenter;
  final DateTime payAt;
  final int costElementId;
  final CostElement? costElement;
  final TransactionStatus status;
  final int paymentMethodId;
  final PaymentMethod? paymentMethod;
  final String content;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      content: json['content'],
      cost: json['cost'],
      costCenterId: json['costCenterId'],
      costCenter: CostCenter.fromJson(json['costCenter']),
      status: convertStringToTransactionStatus(json['status']),
      payAt: DateTime.parse(json['payAt']),
      costElementId: json['costElementId'],
      costElement: CostElement.fromJson(json['costElement']),
      paymentMethodId: json['paymentMethodId'],
      paymentMethod: PaymentMethod.fromJson(
        json['paymentMethod'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object> get props => [content, status];
}

class TransactionListResponse {
  final List<Transaction> list;
  final bool hasReachedMax;

  const TransactionListResponse({
    required this.list,
    required this.hasReachedMax,
  });
}
