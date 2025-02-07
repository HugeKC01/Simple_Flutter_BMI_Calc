import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart'; //Importing the dynamic_color package for color scheme
import 'package:intl/intl.dart'; //Importing the intl package for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
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
        ],
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'BMI Calculator',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Weight (kg)',
                      ),
                      onChanged: (value) {
                        weight = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Height (cm)',
                      ),
                      onChanged: (value) {
                        height = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          bmi = weight / ((height / 100) * (height / 100));
                          bmi = double.parse(bmi.toStringAsFixed(2));
                          bmiHistory.add({
                            'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            'bmi': bmi,
                          });
                        });
                      },
                      child: const Text('Calculate BMI'),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Your BMI is $bmi'),
                  ],
                ),
              )
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
          ],
        )
      )
    );
  }
}
