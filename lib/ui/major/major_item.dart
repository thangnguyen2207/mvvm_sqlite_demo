import 'package:flutter/material.dart';

import '../../model/major.dart';

class MajorItem extends StatelessWidget {
  final Major major;
  final Function(Major major) onClick;
  final Function(Major major)? onDelete;

  const MajorItem({Key? key, required this.major, required this.onClick, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          InkWell(child: Text(major.name), onTap: () => onClick(major)),
          const Spacer(),
          IconButton(
            onPressed: onDelete == null ? null : () => onDelete!(major),
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