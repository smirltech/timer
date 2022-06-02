library counter_card;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CounterCard extends StatelessWidget {
  const CounterCard(
      {Key? key,
      required this.data,
      required this.onSelected,
      required this.onEdited,
      required this.onDeleted})
      : super(key: key);
  final Map<String, dynamic> data;
  final VoidCallback onSelected;
  final VoidCallback onEdited;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data['description']!),
        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm:ss')
            .format(DateTime.parse(data['date']))
            .toString()),
        onTap: onSelected,
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdited,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeleted,
            ),
          ],
        ),
      ),
    );
  }
}
