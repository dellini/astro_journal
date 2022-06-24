import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/diary/hive_diary_note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

enum DiaryCreateState { initial, updated, error }

class DiaryCreateCubit extends Cubit<DiaryCreateState> {
  final DateTime date;

  final DiaryNoteRepositoryHive _repository;

  final DiaryNote? _originalNote;

  bool get canSave => name.isNotEmpty;

  String get name => _edited.name;
  set name(String v) => _update(() => _edited = _edited.copyWith(name: v));

  String? get situation => _edited.situation;
  set situation(String? v) =>
      _update(() => _edited = _edited.copyWith(situation: v));

  String? get thoughts => _edited.thoughts;
  set thoughts(String? v) =>
      _update(() => _edited = _edited.copyWith(thoughts: v));

  String? get emotion => _edited.emotion;
  set emotion(String? v) =>
      _update(() => _edited = _edited.copyWith(emotion: v));

  String? get bodyReaction => _edited.bodyReaction;
  set bodyReaction(String? v) =>
      _update(() => _edited = _edited.copyWith(bodyReaction: v));

  late DiaryNote _edited;

  DiaryCreateCubit({
    required DiaryNoteRepositoryHive repository,
    required this.date,
    DiaryNote? initial,
  })  : _originalNote = initial,
        _repository = repository,
        super(DiaryCreateState.initial) {
    _edited = _originalNote ??
        DiaryNote(
          date: DateTime(0),
          name: '',
        );
  }

  Future<void> save() async {
    await _repository.save(
      _edited.copyWith(
        date: _originalNote != null ? _originalNote?.date : date,
      ),
    );
  }

  void _update(VoidCallback? action) {
    action?.call();
    emit(DiaryCreateState.updated);
  }
}
