import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _name = TextEditingController();
  final _dept = TextEditingController();
  final _salary = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<EmployeeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _dept, decoration: const InputDecoration(labelText: 'Department ID'), keyboardType: TextInputType.number),
            TextField(controller: _salary, decoration: const InputDecoration(labelText: 'Salary'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                final name = _name.text.trim();
                final deptId = int.tryParse(_dept.text.trim()) ?? 1;
                final salary = double.tryParse(_salary.text.trim()) ?? 0.0;
                if (name.isEmpty) return;
                await prov.addEmployee(Employee(name: name, departmentId: deptId, salary: salary));
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
