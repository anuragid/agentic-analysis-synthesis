// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'design_principle.dart';

DesignPrinciple _$DesignPrincipleFromJson(Map<String, dynamic> json) =>
    DesignPrinciple(
      principle: json['principle'] as String,
      insightId: json['insight_id'] as String,
      actionVerbs: (json['action_verbs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      designDirection: json['design_direction'] as String,
      priority: (json['priority'] as num).toDouble(),
    );

Map<String, dynamic> _$DesignPrincipleToJson(DesignPrinciple instance) =>
    <String, dynamic>{
      'principle': instance.principle,
      'insight_id': instance.insightId,
      'action_verbs': instance.actionVerbs,
      'design_direction': instance.designDirection,
      'priority': instance.priority,
    };

