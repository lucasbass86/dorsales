import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearWidget extends StatefulWidget {
  final String year;
  const YearWidget({required this.year});

  @override
  State<YearWidget> createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  @override
  Widget build(BuildContext context) {
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    return GestureDetector(
      onTap: () => setState(() => generalProvider.selYear = widget.year),
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        decoration: BoxDecoration(
          color: widget.year == generalProvider.selYear ? Utils.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.year.toString(),
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
