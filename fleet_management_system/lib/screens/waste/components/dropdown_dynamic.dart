import 'package:flutter/material.dart';

class DynamicDropDown extends StatefulWidget {
  final Map<String, int> choices;
  const DynamicDropDown({super.key, required this.choices});

  @override
  State<DynamicDropDown> createState() => _DynamicDropDownState();
}

class _DynamicDropDownState extends State<DynamicDropDown> {
// Initial Selected Value
  String dropdownvalue = '';
  Map<String, int> wasteNatureChoices = {
    'Organic': 1,
    'Plastic': 2,
    'Glass': 3,
    'Debris': 4
  };

// List of items in our dropdown menu
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      items = wasteNatureChoices.keys.toList();
      dropdownvalue = items[0];
    });
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
            value: dropdownvalue,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
                print(dropdownvalue);
              });
            },
            underline: Container()),
      ),
    );
  }
}

/*
 DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select an option'),
                  onChanged: (newValue) {
                    setState(() {
                      wasteNature = newValue!;
                    });
                  },
                  //(wasteNatureChoices.keys.toList())
                  items: ['Ch 1', 'Ch2', 'Ch3'].map<DropdownMenuItem<String>>(
                    (String value) {
                      print('Waste nature: , $wasteNature');
                      return DropdownMenuItem<String>(
                        value: value,
                        // value: wasteNatureChoices[value]
                        //     .toString(), // Assuming 'id' is a string or can be converted to one
                        child: Text(
                            value), //value // Assuming 'name' is a string or can be converted to one
                      );
                    },
                  ).toList(),
                  value: wasteNature,
                ),
                
*/
