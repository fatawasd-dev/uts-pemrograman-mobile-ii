import 'package:flutter/material.dart';

class EditExpensePage extends StatefulWidget {
  final Map<String, String> expense;
  final Function(Map<String, String>) onEditExpense;

  const EditExpensePage({
    super.key,
    required this.expense,
    required this.onEditExpense,
  });

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _categories = ["Makanan", "Bensin", "Jajan", "Keperluan"];
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense['title']);
    _amountController = TextEditingController(
      text: widget.expense['amount']?.replaceAll('Rp ', ''),
    );
    _selectedCategory = widget.expense['category'] ?? "Makanan";
    _selectedDate = DateTime.tryParse(widget.expense['date'] ?? '');
    _selectedTime = widget.expense['time'] != null
        ? _parseTimeOfDay(widget.expense['time']!)
        : null;
  }

  void _submitEdit() {
    final updatedTitle = _titleController.text;
    final updatedAmount = _amountController.text;

    if (updatedTitle.isEmpty ||
        updatedAmount.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Judul, jumlah, tanggal, dan waktu harus diisi")),
      );
      return;
    }

    final updatedExpense = {
      'title': updatedTitle,
      'amount': 'Rp $updatedAmount',
      'category': _selectedCategory,
      'date': _selectedDate!.toLocal().toString().split(' ')[0],
      'time': _selectedTime!.format(context),
    };

    widget.onEditExpense(updatedExpense);
    Navigator.of(context).pop();
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final format = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)');
    final match = format.firstMatch(timeString);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);
      final String period = match.group(3)!;

      if (period == "PM" && hour != 12) {
        hour += 12;
      } else if (period == "AM" && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } else {
      throw FormatException("Invalid time format: $timeString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pengeluaran"),
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
                  _selectedCategory = newValue!;
                });
              },
            ),
            ListTile(
              title: const Text('Pilih Tanggal'),
              subtitle: Text(_selectedDate == null
                  ? 'Belum memilih tanggal'
                  : '${_selectedDate!.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Pilih Jam'),
              subtitle: Text(_selectedTime == null
                  ? 'Belum memilih waktu'
                  : _selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitEdit,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
