import 'package:flutter/material.dart';
import 'package:my_office/features/food_count/data/model/food_count_model.dart';

class CountDetailScreen extends StatefulWidget {
  final FoodCountModel allFoodCountList;
  const CountDetailScreen({super.key, required this.allFoodCountList});

  @override
  State<CountDetailScreen> createState() => _CountDetailScreenState();
}

class _CountDetailScreenState extends State<CountDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.allFoodCountList.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody(){
    return ListView.builder(
      itemCount: widget.allFoodCountList.foodDates.length,
      itemBuilder: (ctx, i){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
          child: Text(
            '${widget.allFoodCountList.foodDates[i]}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
