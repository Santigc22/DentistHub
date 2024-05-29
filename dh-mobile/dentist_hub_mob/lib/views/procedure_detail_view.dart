import 'package:dentist_hub_mob/views/edit_procedure_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProcedureDetailView extends StatelessWidget {
  final Map<String, dynamic> procedure;
  final String serverIp = '192.168.1.46';

  ProcedureDetailView({required this.procedure, Key? key}) : super(key: key);

  Future<void> deleteProcedure(BuildContext context) async {
    final String deleteProcedureURL =
        'http://$serverIp:5000/dentisthub/api/procedures/${procedure['id_procedure']}';
    try {
      final response = await http.delete(Uri.parse(deleteProcedureURL));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Procedure deleted'),
            content: const Text('The procedure has been deleted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Error al eliminar procedure: ${response.body}');
      }
    } catch (e) {
      print('Error de red al eliminar procedure: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedure  Details'),
        backgroundColor: const Color(0xFFCE93D8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${procedure['name']}',
                style: const TextStyle(fontSize: 18)),
            Text('Amount: ${procedure['amount']}',
                style: const TextStyle(fontSize: 18)),
            Text('Description: ${procedure['description']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProcedureView(procedure: procedure),
                      ),
                    );
                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this procedure?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                    if (confirmDelete) {
                      deleteProcedure(procedure['id_procedure']);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
