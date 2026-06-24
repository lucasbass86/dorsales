import 'package:animate_do/animate_do.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistanceWidget extends StatefulWidget {
  final String distance;
  const DistanceWidget({required this.distance});

  @override
  State<DistanceWidget> createState() => _DistanceWidgetState();
}

class _DistanceWidgetState extends State<DistanceWidget> {
  @override
  Widget build(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          generalProvider.selDistance = widget.distance;
        });
      },
      child: ElasticInUp(
        child: Container(
          margin: const EdgeInsets.all(12),
          width: Utils.filterWidgetSize,
          height: Utils.filterWidgetSize,
          decoration: BoxDecoration(
            color: widget.distance == generalProvider.selDistance ? Utils.grey : Utils.blue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.distance == generalProvider.selDistance ? Utils.greyShadow : Colors.transparent,
                offset: const Offset(5, 5),
                blurRadius: Utils.blurRadius,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.distance.toString(),
              style: const TextStyle(fontSize: Utils.filterWidgetFontSize, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
