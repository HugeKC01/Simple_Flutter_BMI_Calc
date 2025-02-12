import 'package:flutter/material.dart';
//Importing the dynamic_color package for color scheme
import 'package:dynamic_color/dynamic_color.dart';
import 'package:intl/intl.dart'; //Importing the intl package for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final ColorScheme lightColorScheme = lightDynamic?.harmonized()
          ?? ColorScheme.fromSeed(seedColor: Colors.blue);
        final ColorScheme darkColorScheme = darkDynamic?.harmonized()
          ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
        return MaterialApp(
          title: 'BMI Calculator',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: 'BMI Calculator'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double weight = 0.0;
  double height = 0.0;
  double bmi = 0.0;
  List<Map<String, dynamic>> bmiHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return _historyList();
                },
              );
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return _addBMIDialog(context);
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
                Container(
                alignment: Alignment.topLeft,
                child: Text(
                  bmiHistory.isNotEmpty
                    ? 'Your latest BMI: ${bmiHistory.last['bmi']}'
                    : 'No BMI data available',
                  style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _historyList() {
    return SizedBox(
      height: 300.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BMI History',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true, //This is important to avoid the error of infinite height
              physics: const NeverScrollableScrollPhysics(), //This is important to avoid the error of infinite height 
              itemCount: bmiHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Date: ${bmiHistory[index]['date']}'),
                  subtitle: Text('BMI: ${bmiHistory[index]['bmi']}'),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Title(color: Colors.black, 
                child: Text("Testing Container"))
            ),
          ],
        )
      )
    );
  }

  Widget _addBMIDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Add BMI'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Weight (kg)',
            ),
            onChanged: (value) {
              weight = double.tryParse(value) ?? 0.0;
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
              labelText: 'Height (cm)',
            ),
            onChanged: (value) {
              height = double.tryParse(value) ?? 0.0;
            },
         ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
           Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              bmi = weight / ((height / 100) * (height / 100));
              bmiHistory.add(
                {
                  'date': DateFormat.yMd().format(DateTime.now()),
                  'bmi': bmi.toStringAsFixed(2),
                }
              );
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}