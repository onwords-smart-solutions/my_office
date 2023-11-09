
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/food_count_provider.dart';

class FoodCountScreen extends StatefulWidget {
  const FoodCountScreen({Key? key}) : super(key: key);

  @override
  State<FoodCountScreen> createState() => _FoodCountScreenState();
}

class _FoodCountScreenState extends State<FoodCountScreen> {
  final Map<String, String> month = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  @override
  Widget build(BuildContext context) {
    // Obtain FoodCountProvider from the context
    final foodCountProvider = Provider.of<FoodCountProvider>(context);

    // Trigger the data loading when the widget is loaded
    // This might be moved to the initState if you only want to load data when the screen is first created
    if (foodCountProvider.allFoodCountList.isEmpty && !foodCountProvider.isLoading) {
      foodCountProvider.fetchAllFoodCount(foodCountProvider.currentMonth);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Count Details'),
        // Rest of your AppBar setup
      ),
      body: foodCountProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: foodCountProvider.allFoodCountList.length,
        itemBuilder: (context, index) {
          final foodCount = foodCountProvider.allFoodCountList[index];
          return ListTile(
            // Your ListTile setup
            title: Text(foodCount.name),
            subtitle: Text(foodCount.department),
            // Add other properties like leading, trailing etc.
          );
        },
      ),
      // Rest of your Scaffold body if needed
    );
  }

// Optionally, you might want to have other UI methods or widgets to break down the build method
}
