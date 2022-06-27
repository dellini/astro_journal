import 'package:astro_journal/data/diary_note.dart';
import 'package:astro_journal/modules/calendar/diary/diary_create_cubit.dart';
import 'package:astro_journal/modules/calendar/diary/diary_cubit.dart';
import 'package:astro_journal/modules/shared/app_text_styles.dart';
import 'package:astro_journal/theme.dart';
import 'package:astro_journal/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiaryEditScreen extends StatefulWidget {
  final DiaryNote? initial;
  final DateTime? dateTime;

  const DiaryEditScreen({super.key, this.initial, this.dateTime});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late final DiaryCreateCubit _diaryCreateCubit;
  late final DiaryNotesCubit _diaryListCubit;

  @override
  void initState() {
    super.initState();
    _diaryListCubit = context.read();
    _diaryCreateCubit = DiaryCreateCubit(
      initial: widget.initial,
      repository: context.read(),
      date: _diaryListCubit.loadedDate ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _diaryCreateCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: StreamBuilder(
                      stream: _diaryCreateCubit.stream,
                      builder: (context, snapshot) {
                        return ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(60, 80, 30, 100),
                          children: [
                            _TextInput(
                              label: 'Название',
                              initialValue: _diaryCreateCubit.name,
                              onChanged: (s) => _diaryCreateCubit.name = s,
                            ),
                            const SizedBox(height: 30),
                            _TextInput(
                              label: 'Ситуация',
                              initialValue: _diaryCreateCubit.situation,
                              onChanged: (s) => _diaryCreateCubit.situation = s,
                            ),
                            const SizedBox(height: 30),
                            _TextInput(
                              label: 'Мысли',
                              initialValue: _diaryCreateCubit.thoughts,
                              onChanged: (s) => _diaryCreateCubit.thoughts = s,
                            ),
                            const SizedBox(height: 30),
                            _TextInput(
                              label: 'Эмоции',
                              initialValue: _diaryCreateCubit.emotion,
                              onChanged: (s) => _diaryCreateCubit.emotion = s,
                            ),
                            const SizedBox(height: 30),
                            _TextInput(
                              label: 'Реакция тела',
                              initialValue: _diaryCreateCubit.bodyReaction,
                              onChanged: (s) =>
                                  _diaryCreateCubit.bodyReaction = s,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const PositionedBackButton(),
                ],
              ),
            ),
            Container(
              color: AppColors.backgroundColor,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: AppButton(
                text: 'Сохранить',
                onPressed: () {
                  if (!_diaryCreateCubit.canSave) {
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  _diaryCreateCubit.save().then((_) {
                    _diaryListCubit.loadNotes(widget.dateTime);
                    context.pop();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String label;
  final String? initialValue;
  final void Function(String)? onChanged;

  const _TextInput({
    required this.label,
    this.initialValue,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16));
    return TextFormField(
      style: AppTextStyles.secondaryTextStyle.copyWith(
        fontSize: 20,
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      cursorColor: Colors.white,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.primaryTextStyle,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.amberAccent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.amberAccent),
        ),
      ),
    );
  }
}
