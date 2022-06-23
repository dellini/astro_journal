import 'package:astro_journal/hive_types.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'diary_note.g.dart';

@HiveType(typeId: HiveTypes.diaryNote)
class DiaryNote with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String? situation;
  @HiveField(4)
  final String? thoughts;
  @HiveField(5)
  final String? emotion;
  @HiveField(6)
  final String? bodyReaction;

  @override
  List<Object?> get props => [id];

  DiaryNote({
    required this.date,
    required this.name,
    String? id,
    this.situation,
    this.thoughts,
    this.emotion,
    this.bodyReaction,
  }) : id = id ?? const Uuid().v4();

  DiaryNote copyWith({
    String? name,
    String? situation,
    String? thoughts,
    String? emotion,
    String? bodyReaction,
    DateTime? date,
  }) {
    return DiaryNote(
      id: id,
      date: date ?? this.date,
      name: name ?? this.name,
      situation: situation ?? this.situation,
      thoughts: thoughts ?? this.thoughts,
      emotion: emotion ?? this.emotion,
      bodyReaction: bodyReaction ?? this.bodyReaction,
    );
  }
}
