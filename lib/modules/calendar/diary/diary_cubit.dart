import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/diary/hive_diary_note_repository.dart';
import 'package:bloc/bloc.dart';

enum DiaryNotesState { initial, loading, updated, error }

class DiaryNotesCubit extends Cubit<DiaryNotesState> {
  final DiaryNoteRepositoryHive diaryNotesRepository;

  List<DiaryNote> get notes => List.unmodifiable(_notes);
  List<DiaryNote> _notes = [];

  DiaryNotesCubit({
    required this.diaryNotesRepository,
  }) : super(DiaryNotesState.initial);

  void loadNotes(DateTime? date) {
    emit(DiaryNotesState.loading);
    if (date == null) {
      _notes = diaryNotesRepository.getAll();
    } else {
      _notes = diaryNotesRepository.getNotesByDate(date);
    }

    emit(DiaryNotesState.updated);
  }
}
