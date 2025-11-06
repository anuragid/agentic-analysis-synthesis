import 'package:json_annotation/json_annotation.dart';

part 'pattern.g.dart';

@JsonSerializable()
class Pattern {
  final String name;
  final String description;
  final List<String> relatedInferences;
  final List<String> themes;
  final double strength;

  const Pattern({
    required this.name,
    required this.description,
    required this.relatedInferences,
    required this.themes,
    required this.strength,
  });

  factory Pattern.fromJson(Map<String, dynamic> json) =>
      _$PatternFromJson(json);

  Map<String, dynamic> toJson() => _$PatternToJson(this);
}

