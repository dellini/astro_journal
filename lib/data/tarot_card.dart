class TarotCard {
  final String type;
  final String nameShort;
  final String name;
  final String value;
  final int valueInt;
  final String meaning;
  final String desc;

  String get arcane => type == 'major' ? 'Старший' : 'Младший';

  TarotCard({
    required this.type,
    required this.nameShort,
    required this.name,
    required this.value,
    required this.valueInt,
    required this.meaning,
    required this.desc,
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
    );
  }

  @override
  String toString() {
    return 'Аркан: $arcane, Название: $name, Значение карты: $meaning';
  }
}
