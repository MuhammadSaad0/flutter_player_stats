import 'package:flutter/material.dart';
import 'package:chart_components/chart_components.dart';

class StatsBar extends StatefulWidget {
  final List<double> stats;
  final String? imgUrl;
  const StatsBar({Key? key, required this.stats, required this.imgUrl})
      : super(key: key);

  @override
  State<StatsBar> createState() => _StatsBarState();
}

class _StatsBarState extends State<StatsBar> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      labelStyle: TextStyle(
          fontSize: 9,
          color: widget.imgUrl == null ? Colors.white : Colors.black),
      labels: const ["Apps", "Goals", "Yellows", "Reds"],
      displayValue: widget.imgUrl == null ? false : true,
      roundValuesOnText: false,
      barWidth: 30,
      footerHeight: 24,
      headerValueHeight: 16,
      barSeparation: 54,
      animationCurve: Curves.elasticInOut,
      lineGridColor: widget.imgUrl != null ? Colors.green : Colors.white,
      data: widget.stats,
      animationDuration: const Duration(seconds: 4),
      getColor: (double value) {
        return const Color.fromARGB(166, 18, 0, 0);
      },
    );
  }
}
