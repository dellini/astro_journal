
import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/calendar/diary/hive_diary_note_repository.dart';
import 'package:bloc/bloc.dart';

enum DiaryNotesState { initial, loading, updated, error }

class DiaryNotesCubit extends Cubit<DiaryNotesState> {
  final DiaryNoteRepositoryHive diaryNotesRepository;

  Map<DateTime, List<DiaryNote>> get notesByDay =>
      Map.unmodifiable(_notesByDay);

  List<DiaryNote> get notes => List.unmodifiable(_notes);
  DateTime? get loadedDate => _loadedDate;

  Map<DateTime, List<DiaryNote>> _notesByDay = {};

  List<DiaryNote> _notes = [];

  DateTime? _loadedDate;

  DiaryNotesCubit({
    required this.diaryNotesRepository,
  }) : super(DiaryNotesState.initial);

  void loadNotes([DateTime? date]) {
    emit(DiaryNotesState.loading);
    _loadedDate = date;
    if (date == null) {
      _notes = diaryNotesRepository.getAll();
    } else {
      _notes = diaryNotesRepository.getNotesByDate(date.onlyDate);
    }
    _notesByDay = _groupNotesByDay(notes);

    emit(DiaryNotesState.updated);
  }

  Future<void> delete(DiaryNote note) async {
    await diaryNotesRepository.delete(note);
  }

  Map<DateTime, List<DiaryNote>> _groupNotesByDay(List<DiaryNote> data) {
    final result = <DateTime, List<DiaryNote>>{};
    for (final e in data) {
      result.putIfAbsent(e.date.onlyDate, () => []).add(e);
    }
    return result;
  }
}
