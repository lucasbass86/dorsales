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
      onTap: () => setState(() => generalProvider.selDistance = widget.distance),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.distance == generalProvider.selDistance ? Utils.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.distance.toString(),
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
