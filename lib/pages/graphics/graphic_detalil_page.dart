import 'package:dorsales/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/utils/utils.dart';

class GraphicDetalilPage extends StatefulWidget {
  static const String routeName = 'GraphicDetalilPage';
  const GraphicDetalilPage({Key? key}) : super(key: key);

  @override
  State<GraphicDetalilPage> createState() => _GraphicDetalilPageState();
}

class _GraphicDetalilPageState extends State<GraphicDetalilPage> {
  late DorsalService dorsalService;
  List<int> distinct = [];
  int? selected;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    dorsalService = Provider.of<DorsalService>(context, listen: false);
    distinct = dorsalService.dorsales.map((e) => e.distancia).toSet().toList()
      ..sort((a, b) => a.compareTo(b));
    final arguments = ModalRoute.of(context)?.settings.arguments as int?;
    if (arguments != null && isLoading) {
      isLoading = false;
      selected = arguments;
    }
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            _distances(),
            if (selected != null) _graphic(),
            if (selected == null) _noDistance(),
          ],
        ),
      ),
    );
  }

  Widget _noDistance() {
    return Expanded(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 200,
            color: Utils.blueText.withAlpha(150),
          ),
          Text(
            'Selecciona la distancia',
            style: TextStyle(fontSize: 21, color: Utils.blueText),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 1,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            spacing: 5,
            children: [
              Text(
                'Mis',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Text(
                'Dorsales',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Utils.blue),
              ),
            ],
          ),
        ));
  }

  Widget _distances() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona distancia para ver detalles',
          style: TextStyle(fontSize: 19),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), border: Border.all(color: Utils.blueText)),
          child: DropdownButton<int>(
            value: selected,
            isExpanded: true,
            underline: Container(),
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
            items:
                distinct.map((d) => DropdownMenuItem(value: d, child: Text(d.toString()))).toList(),
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ],
    );
  }

  Widget _graphic() {
    List<Dorsal> dorsales = dorsalService.dorsales.where((b) => b.distancia == selected).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
    List<_ChartInfo> info = [];
    for (Dorsal d in dorsales) {
      if (d.fecha.isEmpty) continue;
      Duration duration = Duration.zero;
      if (d.tiempo.isNotEmpty && d.tiempo.replaceAll('0', '').replaceAll(':', '').isNotEmpty) {
        List<String> durations = d.tiempo.split(':');
        int hourDuration = durations.length == 3 ? int.parse(durations[0]) : 0;
        int minDuration = durations.length == 3 ? int.parse(durations[1]) : int.parse(durations[0]);
        int secDuration = durations.length == 3 ? int.parse(durations[2]) : int.parse(durations[1]);
        duration = Duration(hours: hourDuration, minutes: minDuration, seconds: secDuration);
      }
      info.add(_ChartInfo(dorsal: d, dateTime: DateTime.parse(d.fecha), duration: duration));
    }
    List<CartesianSeries<_ChartInfo, DateTime>> series = [
      SplineSeries<_ChartInfo, DateTime>(
        dataSource: info,
        xValueMapper: (_ChartInfo statisct, _) => statisct.dateTime,
        yValueMapper: (_ChartInfo statisct, _) => statisct.duration.inSeconds,
        name: 'Distancia: $selected',
        dataLabelSettings: DataLabelSettings(isVisible: true),
        dataLabelMapper: (item, _) => formatDuration(item.duration.inSeconds),
        sortingOrder: SortingOrder.ascending,
        color: Utils.blue,
        enableTooltip: true,
        markerSettings: MarkerSettings(isVisible: true),
      ),
    ];
    final minSeconds =
        info.isNotEmpty ? info.map((e) => e.duration.inSeconds).reduce((a, b) => a < b ? a : b) : 0;
    final roundedMin = (minSeconds ~/ 60) * 60;

    return Expanded(
      child: SfCartesianChart(
        primaryYAxis: NumericAxis(
          interval: 60,
          minimum: roundedMin.toDouble(),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
              formatDuration(details.value.toInt()),
              const TextStyle(),
            );
          },
        ),
        primaryXAxis: CategoryAxis(
          interval: 1,
          labelRotation: 20,
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
              Utils.dateEnglishToSpanish(DateTime.parse(details.text)),
              const TextStyle(),
            );
          },
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enableDoubleTapZooming: true,
          enableSelectionZooming: true,
          enableMouseWheelZooming: true,
          enablePanning: true,
        ),
        legend: Legend(alignment: ChartAlignment.near),
        series: series,
        tooltipBehavior: TooltipBehavior(
          enable: true,
          builder: (data, point, series, pointIndex, seriesIndex) {
            final info = data as _ChartInfo;
            return IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Utils.blue),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  spacing: 20,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (series.name != null && series.name!.isNotEmpty) ...[
                          Text(series.name!),
                          const SizedBox(height: 4),
                          Container(
                            height: 1,
                            color: Utils.blueText,
                            width: 100,
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          '${Utils.dateEnglishToSpanish(info.dateTime)}:   ${Utils.durationToString(info.duration)}',
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, BibNumberDetailPage.routeName,
                          arguments: info.dorsal),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                        decoration: BoxDecoration(
                            color: Utils.blue, borderRadius: BorderRadius.circular(20)),
                        child: Text('Ver'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

class _ChartInfo {
  final Dorsal dorsal;
  final DateTime dateTime;
  final Duration duration;
  @override
  String toString() =>
      '${Utils.dateEnglishToSpanish(dateTime)}: ${Utils.durationToString(duration)}';
  _ChartInfo({
    required this.dorsal,
    required this.dateTime,
    required this.duration,
  });
}
