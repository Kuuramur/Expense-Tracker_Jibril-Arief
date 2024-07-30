import 'package:expense_tracker_app/components/bar_graph/bar_graph.dart';
import 'package:expense_tracker_app/helpers/utils.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    String sun =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String mon =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tue =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wed =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thu =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String fri =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sat =
        Utils.convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseProvider>(
      builder: (context, value, child) {
        double maxY = 100000;
        if (Provider.of<ExpenseProvider>(context, listen: false)
                .getTotalAmountThisWeek()
                .toDouble() >
            50000) {
          maxY = maxY * 2;
        }
        return Container(
          height: 250,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: MyBarGraph(
            maxY: maxY,
            sunAmount: value.calculateDailyExpenseSummary()[sun] ?? 0,
            monAmount: value.calculateDailyExpenseSummary()[mon] ?? 0,
            tueAmount: value.calculateDailyExpenseSummary()[tue] ?? 0,
            wedAmount: value.calculateDailyExpenseSummary()[wed] ?? 0,
            thuAmount: value.calculateDailyExpenseSummary()[thu] ?? 0,
            friAmount: value.calculateDailyExpenseSummary()[fri] ?? 0,
            satAmount: value.calculateDailyExpenseSummary()[sat] ?? 0,
          ),
        );
      },
    );
  }
}
