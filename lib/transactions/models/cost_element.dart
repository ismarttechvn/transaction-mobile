import 'package:equatable/equatable.dart';

final class CostElement extends Equatable {
  const CostElement({
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

  factory CostElement.fromJson(Map<String, dynamic> json) {
    return CostElement(
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
