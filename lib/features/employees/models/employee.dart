/// Employee record used by the local Employees demo screen.
class Employee {
  const Employee({
    required this.employeeId,
    required this.fullName,
    required this.position,
    required this.department,
    required this.phone,
    required this.email,
    required this.active,
    required this.hireDate,
  });

  final String employeeId;
  final String fullName;
  final String position;
  final String department;
  final String phone;
  final String email;
  final bool active;
  final DateTime hireDate;
}
