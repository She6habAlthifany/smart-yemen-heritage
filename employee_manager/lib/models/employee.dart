class Employee {
  final int? id;
  final String name;
  final int departmentId;
  final double salary;

  Employee({this.id, required this.name, required this.departmentId, required this.salary});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'departmentId': departmentId,
      'salary': salary,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as int?,
      name: map['name'],
      departmentId: map['departmentId'],
      salary: map['salary']?.toDouble() ?? 0.0,
    );
  }
}
