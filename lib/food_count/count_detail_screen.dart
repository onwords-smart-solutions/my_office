import 'package:flutter/material.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/colors/constant_colors.dart';
import '../models/food_count_model.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: Text(
                  widget.allFoodCountList.foodDates[i],
              ),
          );
        },
    );
  }
}
