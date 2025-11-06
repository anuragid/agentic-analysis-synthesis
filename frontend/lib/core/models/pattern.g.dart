// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'pattern.dart';

Pattern _$PatternFromJson(Map<String, dynamic> json) => Pattern(
      name: json['name'] as String,
      description: json['description'] as String,
      relatedInferences: (json['related_inferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      themes: (json['themes'] as List<dynamic>).map((e) => e as String).toList(),
      strength: (json['strength'] as num).toDouble(),
    );

Map<String, dynamic> _$PatternToJson(Pattern instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'related_inferences': instance.relatedInferences,
      'themes': instance.themes,
      'strength': instance.strength,
    };

