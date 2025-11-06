// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'chunk.dart';

Chunk _$ChunkFromJson(Map<String, dynamic> json) => Chunk(
      id: json['id'] as String,
      content: json['content'] as String,
      source: json['source'] as String,
      type: json['type'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChunkToJson(Chunk instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'source': instance.source,
      'type': instance.type,
      'confidence': instance.confidence,
      'tags': instance.tags,
    };

