import 'package:dentist_hub_mob/views/client_detail_view.dart';
import 'package:dentist_hub_mob/views/create_client_view.dart';
import 'package:dentist_hub_mob/views/edit_client_view.dart';
import 'package:dentist_hub_mob/views/procedures_view.dart';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';
import 'package:dentist_hub_mob/function.dart';
import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:http/http.dart' as http;

class ClientsView extends StatefulWidget {
  static String id = 'clients_view';

  @override
  _ClientsViewState createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final String serverIp = '192.168.1.46';
  final String GETClientsURL =
      'http://192.168.1.46:5000/dentisthub/api/clients';
  late List<dynamic> clients = [];

  @override
  void initState() {
    super.initState();
    fetchData(GETClientsURL).then((data) {
      if (data != null) {
        setState(() {
          clients = data;
        });
      }
    });
  }

  Future<void> deleteClient(String id) async {
    final String deleteClientURL =
        'http://192.168.1.46:5000/dentisthub/api/clients/deleteClient/$id';
    try {
      final http.Response response =
          await http.delete(Uri.parse(deleteClientURL));

      if (response.statusCode == 200) {
        setState(() {
          clients.removeWhere((client) => client['id_client'] == id);
        });
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
        title: const Text('Clients 👨‍💼'),
        backgroundColor: const Color(0xFFCE93D8),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFCE93D8),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, HomeView.id);
              },
            ),
            ListTile(
              title: const Text('Admins'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (ModalRoute.of(context)?.settings.name != AdminsView.id) {
                  Navigator.pushReplacementNamed(context, AdminsView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Clients'),
              selected: ModalRoute.of(context)?.settings.name == ClientsView.id,
              selectedTileColor: Colors.lightBlue.withOpacity(0.5),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != ClientsView.id) {
                  Navigator.pushReplacementNamed(context, ClientsView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Procedures'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (ModalRoute.of(context)?.settings.name !=
                    ProceduresView.id) {
                  Navigator.pushReplacementNamed(context, ProceduresView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Doctors'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (ModalRoute.of(context)?.settings.name != DoctorsView.id) {
                  Navigator.pushReplacementNamed(context, DoctorsView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Appointments'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Clients 👨‍💼',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('CC')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: clients.map((client) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClientDetailView(client: client),
                            ),
                          );
                          if (result == true) {
                            fetchData(GETClientsURL);
                          }
                        },
                        child: Text(client['name'] ?? ''),
                      )),
                      DataCell(Text(client['cc'].toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditClientView(client: client),
                                ),
                              );
                              if (result == true) {
                                print('Yes');
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm delete'),
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
                          )
                        ],
                      ))
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateClientView.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
