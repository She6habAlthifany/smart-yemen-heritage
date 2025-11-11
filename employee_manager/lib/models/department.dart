class Department {
  final int? id;
  final String name;

  Department({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(id: map['id'] as int?, name: map['name']);
  }
}
