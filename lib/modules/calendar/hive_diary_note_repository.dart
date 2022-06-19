import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/date_extensions.dart';
import 'package:hive/hive.dart';

class DiaryNoteRepositoryHive {
  static const boxName = 'diaryNotesBoxName';

  final Box<DiaryNote> box;

  DiaryNoteRepositoryHive(this.box);

  List<DiaryNote> getNotesByDate(DateTime date) {
    final notes = box.values.where((e) => e.date.date == date).toList();
    return notes;
  }

  Future<void> save(DiaryNote note) async {
    await box.put(note.id, note);
  }

  Future<void> update(DiaryNote note) async {
    final existing = box.get(note.id);
    if (existing != null) {
      await box.put(note.id, note);
    }
  }

  Future<void> delete(DiaryNote note) async {
    await box.delete(note.id);
  }

  Future<void> deleteAll(Iterable<DiaryNote> notes) async {
    await box.deleteAll(notes.map<String>((e) => e.id));
  }
}
