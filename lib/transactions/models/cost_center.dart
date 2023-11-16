import 'package:equatable/equatable.dart';

final class CostCenter extends Equatable {
  const CostCenter({
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.id,
  });

  final int? id;
  final String code;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CostCenter.fromJson(Map<String, dynamic> json) {
    return CostCenter(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object> get props => [code];
}
