import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import 'add_employee_screen.dart';
import 'salary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<EmployeeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: ListView.builder(
        itemCount: prov.employees.length,
        itemBuilder: (context, i) {
          final e = prov.employees[i];
          return ListTile(
            title: Text(e.name),
            subtitle: Text('Dept ID: ${e.departmentId} • Salary: \$${e.salary}'),
            trailing: IconButton(
              icon: const Icon(Icons.monetization_on),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SalaryScreen(employeeId: e.id!)));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEmployeeScreen())),
      ),
    );
  }
}
