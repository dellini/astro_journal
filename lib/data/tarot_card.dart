import 'package:astro_journal/hive_types.dart';
import 'package:hive/hive.dart';

part 'tarot_card.g.dart';

@HiveType(typeId: HiveTypes.tarotCard)
class TarotCard {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String nameShort;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String value;

  @HiveField(4)
  final int valueInt;

  @HiveField(5)
  final String meaning;

  @HiveField(6)
  final String desc;

  @HiveField(7)
  final String imageUrl;

  String get arcane => type == 'major' ? 'Старший' : 'Младший';

  TarotCard({
    required this.type,
    required this.nameShort,
    required this.name,
    required this.value,
    required this.valueInt,
    required this.meaning,
    required this.desc,
    this.imageUrl = '',
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      type: json['type'] as String,
      nameShort: json['name_short'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      valueInt: json['value_int'] as int,
      meaning: json['meaning_up'] as String,
      desc: json['desc'] as String,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Аркан: $arcane, Название: $name, Значение карты: $meaning';
  }

  TarotCard copyWith({String? imageUrl}) {
    return TarotCard(
      type: type,
      nameShort: nameShort,
      name: name,
      value: value,
      valueInt: valueInt,
      meaning: meaning,
      desc: desc,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
