import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  final _myBox = Hive.box('expense_database');

  void saveData(List<ExpenseModel> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseModel> readData() {
    List savedExpenses = _myBox.get("ALL EXPENSES") ?? [];
    List<ExpenseModel> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseModel expense = ExpenseModel(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
