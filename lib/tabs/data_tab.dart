// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:scbsss/models/mood_entry.dart';
import 'package:scbsss/services/data_handler.dart';

// Define a stateful widget for the "Data" tab
class DataTab extends StatefulWidget {
  @override
  State<DataTab> createState() => _DataTabState();
}

// Define the state for the "Data" tab
class _DataTabState extends State<DataTab> {
  // List to store mood entries retrieved from the database
  List<MoodEntry> moodEntries = [];

  // Fetch data from the database when the widget is initialized
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  // Function to fetch data from the database
  Future<void> _getDataFromDatabase() async {
    try {
      List<MoodEntry> entries = await DatabaseHelper().getAllMoodEntries();
      setState(() {
        moodEntries = entries;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Build the UI for the "Data" tab
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Graphs'),
      ),
      body: moodEntries.isEmpty
          ? Center(
        child: Text(
          "No Entry Added!!!",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Moods Data ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Line Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width,
                height:
                MediaQuery.of(context).size.width / 1.5, // You can adjust the height as needed
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: moodEntries
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value.mood.toDouble()))
                            .toList(),
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Bar Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height:
                MediaQuery.of(context).size.width / 2, // You can adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: moodEntries
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.mood.toDouble(),
                            color: Colors.red,
                            width: 10,
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
