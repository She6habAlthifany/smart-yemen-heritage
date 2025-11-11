class SalaryRecord {
  final int? id;
  final int employeeId;
  final double amount;
  final DateTime date;

  SalaryRecord({this.id, required this.employeeId, required this.amount, required this.date});

  Map<String, dynamic> toMap() => {
    'id': id,
    'employeeId': employeeId,
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory SalaryRecord.fromMap(Map<String, dynamic> map) {
    return SalaryRecord(
      id: map['id'] as int?,
      employeeId: map['employeeId'],
      amount: map['amount']?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
    );
  }
}
