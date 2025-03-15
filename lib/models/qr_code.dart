class Items {
  final int? id;
  final String name;
  final String type;
  final int number;

  Items({
    this.id,
    required this.name,
    required this.number,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'number': number,
    };
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      number: map['number'],
    );
  }
}
