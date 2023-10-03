import 'package:flutter/material.dart';

import 'schedule/create/create_schedule.dart';
import 'schedule/view/delete_schedule.dart';

class AdminSchedule extends StatefulWidget {
  const AdminSchedule({super.key});

  @override
  State<AdminSchedule> createState() => _AdminScheduleState();
}

class _AdminScheduleState extends State<AdminSchedule> {
  @override
  Widget build(BuildContext context) {
    return const BottomNavbar();
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    CreateSchedule(),
    ScheduleDelete(title: 'View Schedule', isDeletable: false),
    ScheduleDelete(title: 'Update Schedule', isDeletable: false),
    ScheduleDelete(title: 'Delete Schedule', isDeletable: true)
    // Icon(
    //   Icons.delete,
    //   size: 150,
    //   color: Color.fromARGB(255, 242, 21, 6),
    // )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.green,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.blue,
            ),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.replay_circle_filled_outlined,
              color: Colors.yellow,
            ),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete,
              color: Color.fromARGB(255, 242, 21, 6),
            ),
            label: 'Delete',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
