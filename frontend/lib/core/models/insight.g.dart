// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'insight.dart';

Insight _$InsightFromJson(Map<String, dynamic> json) => Insight(
      headline: json['headline'] as String,
      explanation: json['explanation'] as String,
      patternId: json['pattern_id'] as String,
      nonConsensus: json['non_consensus'] as bool,
      firstPrinciples: json['first_principles'] as bool,
      impactScore: (json['impact_score'] as num).toDouble(),
    );

Map<String, dynamic> _$InsightToJson(Insight instance) => <String, dynamic>{
      'headline': instance.headline,
      'explanation': instance.explanation,
      'pattern_id': instance.patternId,
      'non_consensus': instance.nonConsensus,
      'first_principles': instance.firstPrinciples,
      'impact_score': instance.impactScore,
    };

