import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uts_fahmi/add_expense_page.dart';
import 'package:uts_fahmi/edit_expense_page.dart';
import 'package:uts_fahmi/expense_detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, String>> _expenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencatatan Keuangan"),
      ),
      body: _expenses.isEmpty
          ? const Center(
              child: Text(
                "Belum ada pengeluaran",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                      title: Text(expense['title'] ?? 'Unknown'),
                      subtitle: Text(
                          "${expense['amount']} - ${expense['category']} - ${expense['date']} - ${expense['time']}"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExpenseDetailPage(expense: expense)));
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditExpensePage(
                                    expense: expense, // PASSING DATA
                                    onEditExpense: (updatedExpense) {
                                      setState(() {
                                        _expenses[index] = updatedExpense;
                                      });
                                      showToast("Pengeluaran Diubah!");
                                      showSnackbar(context,
                                          "Berhasil mengubah pengeluaran!");
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmation(index);
                            },
                          ),
                        ],
                      )),
                );
              }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Pengeluaran:"),
            Text(
              "Rp ${_calculateTotalExpenses().toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpensePage(
                onAddExpense: (newExpense) {
                  setState(() {
                    _expenses.add(newExpense);
                  });
                  showToast("Pengeluaran ditambahkan!");
                  showSnackbar(context, "Berhasil mencacat pengeluaran!");
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _calculateTotalExpenses() {
    double total = 0.0;
    for (var expense in _expenses) {
      final amount = double.tryParse(
          expense['amount']!.replaceAll('Rp ', '').replaceAll(',', ''));
      if (amount != null) {
        total += amount;
      }
    }
    return total;
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penghapusan"),
          content:
              const Text("Apakah Anda yakin ingin menghapus pengeluaran ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _expenses.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
