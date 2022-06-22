import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/shared/list_by_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final DiaryNotesCubit _diaryNotesCubit;
  @override
  void initState() {
    super.initState();
    _diaryNotesCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DiaryNotesCubit, DiaryNotesState>(
        bloc: _diaryNotesCubit,
        builder: (context, state) {
          return ListViewByDay<DiaryNote>(
            data: _diaryNotesCubit.notesByDay,
            itemBuilder: (item) {
              return SimpleListItem(
                title: item.name,
                date: item.date,
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
