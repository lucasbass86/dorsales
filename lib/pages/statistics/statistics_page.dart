import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsPage extends StatelessWidget {
  static const String routeName = 'StatisticsPage';
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DorsalService dorsalService = Provider.of<DorsalService>(context, listen: false);
    int total = dorsalService.dorsales.length;
    double totalDistance = dorsalService.dorsales
        .fold(0, (previousValue, element) => previousValue + element.distancia);
    if (totalDistance > 0) totalDistance = totalDistance / 1000;
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          spacing: 40,
          children: [
            _totals(total, totalDistance),
            _graphicDistances(dorsalService, context),
            _graphicYears(dorsalService),
          ],
        ),
      ),
    );
  }

  Widget _graphicDistances(DorsalService dorsalService, BuildContext context) {
    List<int> distinct = dorsalService.dorsales.map((e) => e.distancia).toSet().toList();
    Map<int, int> grouped = {};
    for (int distance in distinct) {
      var item = {distance: dorsalService.dorsales.where((d) => d.distancia == distance).length};
      grouped.addEntries(item.entries);
    }
    List<_BibsForDistance> bibs = [];
    for (var item in grouped.entries) {
      bibs.add(_BibsForDistance(
          bibs: item.value, distance: item.key, color: Utils.getColorOfDistance(item.key)));
    }
    List<CartesianSeries<_BibsForDistance, int>> series = [
      ColumnSeries<_BibsForDistance, int>(
        dataSource: bibs,
        xValueMapper: (_BibsForDistance statisct, _) => statisct.distance,
        yValueMapper: (_BibsForDistance statisct, _) => statisct.bibs,
        name: 'Dorsales',
        dataLabelSettings: DataLabelSettings(isVisible: true),
        sortingOrder: SortingOrder.ascending,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        pointColorMapper: (datum, index) => datum.color,
      ),
    ];
    return BasicContainerWidget(
      borderColor: Utils.grey,
      borderWidth: 2,
      borderRadius: 20,
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Por distancia',
                style: TextStyle(fontSize: 25),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, GraphicDetalilPage.routeName),
                icon: Text(
                  'Ver',
                  style: TextStyle(color: Utils.blueText, fontSize: 19),
                ),
              ),
            ],
          ),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              interval: 1,
              labelRotation: 20,
            ),
            primaryYAxis: NumericAxis(
              decimalPlaces: 0,
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
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ],
      ),
    );
  }

  Widget _graphicYears(DorsalService dorsalService) {
    List<int> years = dorsalService.dorsales
        .where((d) => d.fecha.isNotEmpty)
        .map((e) => DateTime.parse(e.fecha).year)
        .toSet()
        .toList();
    Map<int, int> grouped = {};
    for (int year in years) {
      var item = {
        year: dorsalService.dorsales
            .where((d) => d.fecha.isNotEmpty)
            .where((d) => DateTime.parse(d.fecha).year == year)
            .length
      };
      grouped.addEntries(item.entries);
    }
    List<_BibsForYear> bibs = [];
    for (var item in grouped.entries) {
      bibs.add(_BibsForYear(bibs: item.value, year: item.key));
    }
    List<CartesianSeries<_BibsForYear, int>> series = [
      SplineSeries<_BibsForYear, int>(
        dataSource: bibs,
        xValueMapper: (_BibsForYear statisct, _) => statisct.year,
        yValueMapper: (_BibsForYear statisct, _) => statisct.bibs,
        name: 'Dorsales',
        dataLabelSettings: DataLabelSettings(isVisible: true),
        sortingOrder: SortingOrder.ascending,
        color: Utils.blue,
        markerSettings: MarkerSettings(isVisible: true),
      ),
    ];
    return BasicContainerWidget(
      borderColor: Utils.grey,
      borderWidth: 2,
      borderRadius: 20,
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text(
            'Por año',
            style: TextStyle(fontSize: 25),
          ),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              interval: 1,
              labelRotation: 20,
            ),
            primaryYAxis: NumericAxis(
              decimalPlaces: 0,
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
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ],
      ),
    );
  }

  Widget _totals(int total, double totalDistance) {
    return BasicContainerWidget(
      borderColor: Utils.grey,
      borderWidth: 2,
      borderRadius: 20,
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Totales',
            style: TextStyle(fontSize: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 40,
                    color: Utils.blue.withAlpha(150),
                  ),
                  Text(
                    'Carreras',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                  Text(
                    total.toString(),
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  )
                ],
              ),
              Container(
                width: 1,
                height: 80,
                color: Utils.grey,
                margin: const EdgeInsets.only(right: 20),
              ),
              Column(
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 40,
                    color: Utils.blue.withAlpha(150),
                  ),
                  Text(
                    'Distancia',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                  Text(
                    totalDistance.toStringAsFixed(2),
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  )
                ],
              ),
              Container(
                width: 1,
                height: 80,
                color: Utils.grey,
                margin: const EdgeInsets.only(right: 20),
              ),
              Column(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: 40,
                    color: Utils.blue.withAlpha(150),
                  ),
                  Text(
                    'Tiempo',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),
                  Text(
                    totalDistance.toStringAsFixed(2),
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _BibsForDistance {
  final int bibs;
  final int distance;
  final Color color;

  _BibsForDistance({required this.bibs, required this.distance, required this.color});
}

class _BibsForYear {
  final int bibs;
  final int year;

  _BibsForYear({required this.bibs, required this.year});
}
