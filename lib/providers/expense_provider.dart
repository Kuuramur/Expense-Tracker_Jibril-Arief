import 'package:expense_tracker_app/database/hive_database.dart';
import 'package:expense_tracker_app/helpers/utils.dart';
import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> overallExpenseList = [];
  List<ExpenseModel> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();
  void preparedata() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add expense
  void addNewExpense(ExpenseModel newExpenseItem) {
    overallExpenseList.add(newExpenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //edit expense
  void updateExpense(int index, ExpenseModel updatedExpense) {
    overallExpenseList[index] = updatedExpense;
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void removeNewExpense(ExpenseModel expenseItem) {
    overallExpenseList.remove(expenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thr';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Invalid Day';
    }
  }

  //get start of week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get today date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  //calculate get total expense this week
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = Utils.convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  double getTotalAmountThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    double totalAmount = 0.0;
    for (ExpenseModel expense in overallExpenseList) {
      if (expense.dateTime.isAfter(startOfWeek) &&
          expense.dateTime.isBefore(endOfWeek)) {
        totalAmount += double.parse(expense.amount);
      }
    }

    return totalAmount;
  }
}
