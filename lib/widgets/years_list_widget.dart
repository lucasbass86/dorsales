import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';

class YearsListWidget extends StatelessWidget {
  const YearsListWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: Utils.years.length,
        itemBuilder: (context, index) {
          return YearWidget(year: Utils.years[index]);
        },
      ),
    );
  }
}
