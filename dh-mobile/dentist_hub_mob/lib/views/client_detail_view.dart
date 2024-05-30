import 'package:dentist_hub_mob/views/edit_client_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientDetailView extends StatelessWidget {
  final Map<String, dynamic> client;
  final String serverIp = '192.168.1.46';

  ClientDetailView({required this.client, Key? key}) : super(key: key);

  Future<void> deleteClient(BuildContext context) async {
    final String deleteClientURL =
        'http://$serverIp:5000/dentisthub/api/clients/${client['id_client']}';
    try {
      final response = await http.delete(Uri.parse(deleteClientURL));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Client deleted'),
            content: const Text('The Client has been deleted successfully.'),
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
        print('Error al eliminar client: ${response.body}');
      }
    } catch (e) {
      print('Error de red al eliminar client: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client  Details'),
        backgroundColor: const Color(0xFFCE93D8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${client['name']}',
                style: const TextStyle(fontSize: 18)),
            Text(' ', style: const TextStyle(fontSize: 18)),
            Text('CC: ${client['cc']}', style: const TextStyle(fontSize: 18)),
            Text(' ', style: const TextStyle(fontSize: 18)),
            Text('Age: ${client['age']}', style: const TextStyle(fontSize: 18)),
            Text(' ', style: const TextStyle(fontSize: 18)),
            Text('Phone: ${client['phone']}',
                style: const TextStyle(fontSize: 18)),
            Text(' ', style: const TextStyle(fontSize: 18)),
            Text('Address: ${client['address']}',
                style: const TextStyle(fontSize: 18)),
            Text(' ', style: const TextStyle(fontSize: 18)),
            Text('ID: ${client['id_client']}',
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
                        builder: (context) => EditClientView(client: client),
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
                                'Are you sure you want to delete this client?'),
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
                      deleteClient(client['id_client']);
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
