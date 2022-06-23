import 'package:astro_journal/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _textStyle = TextStyle(
  fontFamily: 'TenorSans',
  fontSize: 24,
  color: Colors.amberAccent,
);

class ListViewByDay<T> extends StatelessWidget {
  final Map<DateTime, List<T>> data;
  final Widget Function(T) itemBuilder;
  const ListViewByDay({
    required this.itemBuilder,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data.entries.toList();
    final now = DateTime.now();
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
                  style: _textStyle.copyWith(
                    fontFamily: 'Lora',
                    color: Colors.white,
                    fontSize: 21,
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
                  style: _textStyle,
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: DateFormat('H:mm', 'ru').format(date),
                      style: const TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
