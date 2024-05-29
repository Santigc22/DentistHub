import 'dart:convert';
import 'package:dentist_hub_mob/views/procedures_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProcedureView extends StatefulWidget {
  static const String id = 'edit_procedure_view';
  final Map<String, dynamic> procedure;

  EditProcedureView({required this.procedure, Key? key}) : super(key: key);

  @override
  _EditProcedureViewState createState() => _EditProcedureViewState();
}

class _EditProcedureViewState extends State<EditProcedureView> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;

  final String serverIp = '192.168.1.46';
  late String editProcedureURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.procedure['name']);
    amountController =
        TextEditingController(text: widget.procedure['amount'].toString());
    descriptionController =
        TextEditingController(text: widget.procedure['description']);
    editProcedureURL =
        'http://$serverIp:5000/dentisthub/api/procedures/updateProcedure/${widget.procedure['id_procedure']}';
  }

  Future<void> _editProcedure() async {
    final String name = nameController.text;
    final String amount = amountController.text;
    final String description = descriptionController.text;

    final Map<String, String> data = {
      'name': name,
      'amount': amount,
      'description': description,
    };

    try {
      final http.Response response = await http.put(
        Uri.parse(editProcedureURL),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Procedure updated'),
            content: const Text('The procedure has been updated seccessfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, ProceduresView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Error al actualizar procedure: ${response.body}');
      }
    } catch (e) {
      print('Error de red al actualizar procedure: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Procedure'),
        backgroundColor: const Color(0xFFCE93D8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _editProcedure,
              child: const Text('Update Procedure'),
            ),
          ],
        ),
      ),
    );
  }
}
