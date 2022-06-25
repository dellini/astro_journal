import 'package:astro_journal/date_extensions.dart';
import 'package:astro_journal/modules/shared/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListViewByDay<T> extends StatelessWidget {
  final Map<DateTime, List<T>> data;
  final Widget Function(T) itemBuilder;
  final String emptyDataString;
  const ListViewByDay({
    required this.itemBuilder,
    required this.data,
    this.emptyDataString = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data.entries.toList();
    final now = DateTime.now();
    if (data.isEmpty) {
      return Center(
        child: Text(
          emptyDataString,
          style: AppTextStyles.primaryTextStyle,
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 50),
      itemCount: data.length,
      // controller: controller.scroll,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final item = data[index];
        final date = item.key;
        final values = item.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 65,
                right: 20,
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.secondaryTextStyle.copyWith(
                    fontSize: 20,
                  ),
                  children: [
                    if (date.onlyDate == now.onlyDate)
                      const TextSpan(text: 'сегодня, '),
                    TextSpan(
                      text: DateFormat('d MMMM', 'ru').format(date),
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: values.length,
              reverse: true,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final value = values[index];
                return itemBuilder(value);
              },
            ),
          ],
        );
      },
    );
  }
}

class SimpleListItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SimpleListItem({
    required this.title,
    required this.date,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 55,
              right: 20,
            ),
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: title,
                  style: AppTextStyles.primaryTextStyle,
                  children: date.hour > 0 && date.minute > 0
                      ? [
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: DateFormat('H:mm', 'ru').format(date),
                            style: AppTextStyles.secondaryTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ]
                      : [],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
