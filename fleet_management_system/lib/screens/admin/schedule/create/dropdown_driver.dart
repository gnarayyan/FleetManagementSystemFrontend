import 'package:flutter/material.dart';

class DriverListDropdown extends StatefulWidget {
  final List<dynamic> options;
  final Map value = {'value': 0};
  DriverListDropdown({super.key, required this.options});
  int getValue() {
    return value['value'];
  }

  @override
  State<DriverListDropdown> createState() => _DriverListDropdownState();
}

class _DriverListDropdownState extends State<DriverListDropdown> {
  late int value;
  late List<dynamic> choices;

  @override
  void initState() {
    super.initState();
    choices = widget.options;
    value = choices[0]['user'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<int>(
            isExpanded: true,
            elevation: 40,
            hint: const Text('Select an option'),
            // Initial Value
            value: value,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: [
              for (var i = 0; i < choices.length; i++)
                DropdownMenuItem(
                    alignment: AlignmentDirectional.topStart,
                    value: choices[i]['user'],
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(choices[i]['avatar']),
                              // width: 60,
                              height: 120,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              choices[i]['full_name'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Color.fromARGB(255, 51, 42, 111),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ))
            ],
            onChanged: (int? newValue) {
              setState(() {
                value = newValue!;
                widget.value['value'] = newValue;
              });
              print('User Id: $value');
            },
            underline: Container()),
      ),
    );
  }
}
