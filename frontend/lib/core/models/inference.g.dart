// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'inference.dart';

Inference _$InferenceFromJson(Map<String, dynamic> json) => Inference(
      chunkId: json['chunk_id'] as String,
      meanings: (json['meanings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      importance: json['importance'] as String,
      context: json['context'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$InferenceToJson(Inference instance) =>
    <String, dynamic>{
      'chunk_id': instance.chunkId,
      'meanings': instance.meanings,
      'importance': instance.importance,
      'context': instance.context,
      'confidence': instance.confidence,
    };

