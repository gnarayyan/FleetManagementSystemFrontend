import 'package:flutter/material.dart';

class AddCollectionPoint extends StatefulWidget {
  const AddCollectionPoint({super.key});

  @override
  State<AddCollectionPoint> createState() => _AddCollectionPointState();
}

class _AddCollectionPointState extends State<AddCollectionPoint> {
  String selectedOption = 'Option 1'; // Selected dropdown option
  TextEditingController labelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Example'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Open Card'),
              onTap: () {
                // Open the card when this drawer item is tapped
                _openCard();
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Choose Collection Route',
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.left,
                ),
                DropdownButton<String>(
                  value: selectedOption,
                  hint: const Text('Select an option'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement the Grant Access logic here
                  },
                  child: const Text('Grant Access'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement the Save logic here
                      },
                      child: const Text('Saves'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement the Cancel logic here
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to open the card
  void _openCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Grant Access',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  // Add your content for the card here
                  Text('Content goes here...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showAddCollectionPoint(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40,
                  top: -40,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          child: const Text('Submitß'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
}
