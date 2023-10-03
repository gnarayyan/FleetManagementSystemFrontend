import 'package:flutter/material.dart';

// Table view
class ViewSchedule extends StatefulWidget {
  const ViewSchedule({super.key});

  @override
  State<ViewSchedule> createState() => _ViewScheduleState();
}

class _ViewScheduleState extends State<ViewSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Schedule')),
      body: DataTable(columns: const [
        DataColumn(
          label: Text('ID'),
        ),
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('Code'),
        ),
        DataColumn(
          label: Text('Quantity'),
        ),
        DataColumn(
          label: Text('Amount'),
        ),
      ], rows: const [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('Arshik')),
          DataCell(Text('5644645')),
          DataCell(Text('3')),
          DataCell(Text('265\$')),
        ])
      ]),
    );
  }
}
