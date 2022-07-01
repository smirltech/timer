import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFormFieldType {
  date,
  time,
  datetime,
}

class DateFormField extends StatelessWidget {
  DateFormField({
    Key? key,
    this.label = 'Date',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateChanged,
    this.dateDisplayFormat = 'dd/MM/yyyy',
    this.timeDisplayFormat = 'HH:mm:ss',
    this.inputBorder = const UnderlineInputBorder(),
    this.type = DateFormFieldType.date,
  }) : super(key: key) {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now();
    lastDate ??= DateTime.now().add(const Duration(days: 30));
    if (type == DateFormFieldType.time) {
      dateDisplayFormat = timeDisplayFormat;
    }

    _controller = TextEditingController(
      text: DateFormat(dateDisplayFormat).format(initialDate!),
    );
  }

  final InputBorder inputBorder;
  final String label;
  late String dateDisplayFormat;
  final String timeDisplayFormat;
  late DateTime? initialDate;
  late DateTime? firstDate;
  late DateTime? lastDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateFormFieldType type;

  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffix: IconButton(
            onPressed: () {
              // if type is date, show date picker
              if (type == DateFormFieldType.date) {
                showDatePicker(
                  context: context,
                  initialDate: initialDate!,
                  firstDate: firstDate!,
                  lastDate: lastDate!,
                ).then((date) {
                  if (date != null) {
                    onDateChanged(date);
                    _controller.text =
                        DateFormat(dateDisplayFormat).format(date);
                  }
                });
              }
              // if type is time, show time picker
              if (type == DateFormFieldType.time) {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(initialDate!),
                ).then((time) {
                  if (time != null) {
                    DateTime tt = DateTime(
                      initialDate!.year,
                      initialDate!.month,
                      initialDate!.day,
                      time.hour,
                      time.minute,
                    );
                    _controller.text = DateFormat('HH:mm').format(
                      tt,
                    );
                    onDateChanged(tt);
                  }
                });
              }
              // if type is datetime, show date and time picker
              if (type == DateFormFieldType.datetime) {
                showDatePicker(
                  context: context,
                  initialDate: initialDate!,
                  firstDate: firstDate!,
                  lastDate: lastDate!,
                ).then((date) {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(date!),
                  ).then((time) {
                    DateTime dd = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time!.hour,
                      time.minute,
                    );
                    onDateChanged(dd);
                    _controller.text = DateFormat(dateDisplayFormat).format(
                      dd,
                    );
                  });
                });
              }
            },
            icon: const Icon(Icons.date_range)),

        // labelStyle: const TextStyle(color: Colors.green),
        border: inputBorder,
      ),
    );
  }
}
