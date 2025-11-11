import 'package:flutter/material.dart';

class SalaryScreen extends StatelessWidget {
  final int employeeId;
  const SalaryScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Records')),
      body: Center(child: Text('Salary screen for employee id: $employeeId')),
    );
  }
}
