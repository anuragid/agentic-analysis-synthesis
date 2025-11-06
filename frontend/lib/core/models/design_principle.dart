import 'package:json_annotation/json_annotation.dart';

part 'design_principle.g.dart';

@JsonSerializable()
class DesignPrinciple {
  final String principle;
  final String insightId;
  final List<String> actionVerbs;
  final String designDirection;
  final double priority;

  const DesignPrinciple({
    required this.principle,
    required this.insightId,
    required this.actionVerbs,
    required this.designDirection,
    required this.priority,
  });

  factory DesignPrinciple.fromJson(Map<String, dynamic> json) =>
      _$DesignPrincipleFromJson(json);

  Map<String, dynamic> toJson() => _$DesignPrincipleToJson(this);
}

