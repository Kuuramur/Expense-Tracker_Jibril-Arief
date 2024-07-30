import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/helpers/utils.dart';
import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // Define InputDecoration for name input field
  final InputDecoration inputDecorName = InputDecoration(
    labelText: 'Name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.purple[50],
  );

  // Define InputDecoration for amount input field
  final InputDecoration inputDecorAmount = InputDecoration(
    labelText: 'Amount',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.purple[50],
  );

  void addNewExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[300],
        title: const Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newExpenseAmountController.text.isNotEmpty &&
                  newExpenseNameController.text.isNotEmpty) {
                ExpenseModel newExpenseItem = ExpenseModel(
                  name: newExpenseNameController.text,
                  amount: newExpenseAmountController.text,
                  dateTime: DateTime.now(),
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .addNewExpense(newExpenseItem);
                Navigator.pop(context);
                newExpenseAmountController.clear();
                newExpenseNameController.clear();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              newExpenseAmountController.clear();
              newExpenseNameController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.purple),
            ),
          )
        ],
      ),
    );
  }

  void editExpenseDialog(ExpenseModel expense, int index) {
    final editExpenseNameController = TextEditingController(text: expense.name);
    final editExpenseAmountController =
        TextEditingController(text: expense.amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[300],
        title: const Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: editExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (editExpenseAmountController.text.isNotEmpty &&
                  editExpenseNameController.text.isNotEmpty) {
                ExpenseModel updatedExpense = ExpenseModel(
                  name: editExpenseNameController.text,
                  amount: editExpenseAmountController.text,
                  dateTime: expense.dateTime, // Keep the original date
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .updateExpense(index, updatedExpense);
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Update",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.purple),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ExpenseProvider>(context, listen: false).preparedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Expense Tracker"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.idCurrencyFormatter(
                          Provider.of<ExpenseProvider>(context)
                              .getTotalAmountThisWeek()
                              .toDouble()),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Utils.getFormattedWeekRange(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),
              const SizedBox(height: 50),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          extentRatio: 0.4,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              onPressed: (context) {
                                // Delete expense from the list
                                Provider.of<ExpenseProvider>(context,
                                        listen: false)
                                    .removeNewExpense(
                                  value.overallExpenseList[index],
                                );
                              },
                            ),
                            SlidableAction(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              onPressed: (context) {
                                // Edit expense from the list
                                editExpenseDialog(
                                    value.getAllExpenseList()[index], index);
                              },
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            value.getAllExpenseList()[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                              '${value.getAllExpenseList()[index].dateTime.day}/${value.getAllExpenseList()[index].dateTime.month}/${value.getAllExpenseList()[index].dateTime.year}'),
                          trailing: Text(
                            Utils.idCurrencyFormatter(
                              double.parse(
                                value.getAllExpenseList()[index].amount,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              addNewExpenseDialog();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
