import 'package:flutter/material.dart';

import '../../model/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  final Function(Student student) onClick;
  final Function(Student student)? onDelete;
  
  const StudentItem({Key? key, required this.student, required this.onClick, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          InkWell(
            child: Text(student.lastName + ' ' + student.firstName),
            onTap: () => onClick(student),
          ),
          const Spacer(),
          IconButton(
            onPressed: onDelete == null ? null : () => onDelete!(student),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )
          )
        ],
      ),
    );
  }
}