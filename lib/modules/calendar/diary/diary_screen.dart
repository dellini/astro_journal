import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
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
    return BlocBuilder<DiaryNotesCubit, DiaryNotesState>(
      bloc: _diaryNotesCubit,
      builder: (context, state) {
        final data = _diaryNotesCubit.notesByDay.entries.toList();
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Container();
          },
        );
      },
    );
  }
}
