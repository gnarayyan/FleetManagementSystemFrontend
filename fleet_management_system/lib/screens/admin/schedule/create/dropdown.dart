import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget {
  final Map<String, int> options;
  final Map value = {'value': 0};
  DropdownCustom({super.key, required this.options});

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();

  int getValue() {
    return value['value'];
  }
}

class _DropdownCustomState extends State<DropdownCustom> {
  late String value;
  late Map<String, int> choices;

  int getValueOfValue() {
    return choices[value] as int;
  }

  @override
  void initState() {
    super.initState();
    choices = widget.options;
    value = choices.keys.toList()[0];
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
        child: DropdownButton(
            isExpanded: true,
            elevation: 12,
            hint: const Text('Select an option'),
            // Initial Value
            value: value,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: (choices.keys.toList()).map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                value = newValue!;
                widget.value['value'] = getValueOfValue();
              });
            },
            underline: Container()),
      ),
    );
  }
}
