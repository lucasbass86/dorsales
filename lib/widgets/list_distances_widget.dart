import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ListDistancesWidget extends StatelessWidget {
  const ListDistancesWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: Utils.distances.length,
        itemBuilder: (context, index) {
          return DistanceWidget(distance: Utils.distances[index]);
        },
      ),
    );
  }
}
