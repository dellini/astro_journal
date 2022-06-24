import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/shared/list_by_day.dart';
import 'package:astro_journal/routes.dart';
import 'package:astro_journal/theme.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black87,
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          context.push(Routes.diaryEdit.path);
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder(
              stream: _diaryNotesCubit.stream,
              builder: (context, snapshot) {
                final data = _diaryNotesCubit.notesByDay.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key) * -1);

                return ListViewByDay<DiaryNote>(
                  emptyDataString: 'В дневнике нет записей',
                  data: Map.fromEntries(data),
                  itemBuilder: (item) {
                    return SimpleListItem(
                      title: item.name,
                      date: item.date,
                      onTap: () {
                        context.push(
                          Routes.diaryEdit.path,
                          extra: DiaryArgs(
                            note: item,
                          ),
                        );
                      },
                      onLongPress: () {
                        _diaryNotesCubit
                          ..delete(item)
                          ..loadNotes();
                      },
                    );
                  },
                );
              },
            ),
          ),
          const PositionedBackButton(),
        ],
      ),
    );
  }
}
