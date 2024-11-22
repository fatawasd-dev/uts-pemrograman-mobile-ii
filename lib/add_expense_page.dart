import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  final Function(Map<String, String>) onAddExpense;

  const AddExpensePage({super.key, required this.onAddExpense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _categories = ["Makanan", "Bensin", "Jajan", "Keperluan"];
  String? _selectedCategory = "Makanan";

  void _submitExpense() {
    final title = _titleController.text;
    final amount = _amountController.text;

    if (title.isEmpty ||
        amount.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan jumlah tidak boleh kosong")),
      );
      return;
    }

    final newExpense = {
      'title': title,
      'amount': 'Rp $amount',
      'category': _selectedCategory!,
        'date': _selectedDate!
            .toLocal()
            .toString()
            .split(' ')[0],
        'time': _selectedTime!.format(context),
    };

    widget.onAddExpense(newExpense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(_selectedDate == null
                  ? 'No date selected'
                  : '${_selectedDate!.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Select Time'),
              subtitle: Text(_selectedTime == null
                  ? 'No time selected'
                  : _selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null && pickedTime != _selectedTime) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}
