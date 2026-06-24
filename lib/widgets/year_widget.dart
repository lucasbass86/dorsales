import 'package:animate_do/animate_do.dart';
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
      onTap: () {
        setState(() {
          generalProvider.selYear = widget.year;
        });
      },
      child: ElasticInDown(
        child: Container(
          margin: const EdgeInsets.all(12),
          width: Utils.filterWidgetSize,
          height: Utils.filterWidgetSize,
          decoration: BoxDecoration(
            color: widget.year == generalProvider.selYear ? Utils.grey : Utils.blue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.year == generalProvider.selYear ? Utils.greyShadow : Colors.transparent,
                offset: const Offset(5, 5),
                blurRadius: Utils.blurRadius,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.year.toString(),
              style: const TextStyle(fontSize: Utils.filterWidgetFontSize, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
