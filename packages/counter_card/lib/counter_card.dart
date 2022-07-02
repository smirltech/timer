library counter_card;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              onPressed: (context) => onEdited(),
              icon: Icons.edit,
              label: 'Modifier',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: (context) => onDeleted(),
              icon: Icons.delete,
              label: 'Supprimer',
            ),
          ],
        ),
        child: ListTile(
          tileColor: data['isDone'] ? Colors.blueGrey[100] : null,
          leading: Icon(
            data['isDone'] ? Icons.check : Icons.check_box_outline_blank,
            color: data['isDone'] ? Colors.green : Colors.grey,
          ),
          title: Text(
            data['description']!,
            style: TextStyle(
                decoration: data['isDone'] ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(DateTime.parse(data['date']))
                .toString(),
            style: TextStyle(
                decoration: data['isDone'] ? TextDecoration.lineThrough : null),
          ),
          onTap: data['isDone'] ? null : onSelected,
          //    trailing: Text(data['timeLeft']),
        ),
      ),
    );
  }
}
