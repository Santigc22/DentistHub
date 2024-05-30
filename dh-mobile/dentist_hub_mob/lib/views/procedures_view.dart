import 'package:dentist_hub_mob/views/create_procedure_view.dart';
import 'package:dentist_hub_mob/views/edit_procedure_view.dart';
import 'package:dentist_hub_mob/views/procedure_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';
import 'package:dentist_hub_mob/function.dart';
import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:http/http.dart' as http;

class ProceduresView extends StatefulWidget {
  static String id = 'procedures_view';

  @override
  _ProceduresViewState createState() => _ProceduresViewState();
}

class _ProceduresViewState extends State<ProceduresView> {
  final String serverIp = '192.168.1.46';
  final String GETProceduresURL =
      'http://192.168.1.46:5000/dentisthub/api/procedures';
  late List<dynamic> procedures = [];

  @override
  void initState() {
    super.initState();
    fetchData(GETProceduresURL).then((data) {
      if (data != null) {
        setState(() {
          procedures = data;
        });
      }
    });
  }

  Future<void> deleteProcedure(String id) async {
    final String deleteProcedureURL =
        'http://192.168.1.46:5000/dentisthub/api/procedures/deleteProcedure/$id';
    try {
      final http.Response response =
          await http.delete(Uri.parse(deleteProcedureURL));

      if (response.statusCode == 200) {
        setState(() {
          procedures
              .removeWhere((procedure) => procedure['id_procedure'] == id);
        });
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
        title: const Text('Procedures 🩹'),
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
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 100));
                if (ModalRoute.of(context)?.settings.name != ClientsView.id) {
                  Navigator.pushReplacementNamed(context, ClientsView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Procedures'),
              selected:
                  ModalRoute.of(context)?.settings.name == ProceduresView.id,
              selectedTileColor: Colors.lightBlue.withOpacity(0.5),
              onTap: () {
                Navigator.pop(context);
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
                'Procedures 🩹',
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
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: procedures.map((procedure) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProcedureDetailView(procedure: procedure),
                            ),
                          );
                          if (result == true) {
                            fetchData(GETProceduresURL);
                          }
                        },
                        child: Text(procedure['name'] ?? ''),
                      )),
                      DataCell(Text('\$${procedure['amount'].toString()}')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProcedureView(procedure: procedure),
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
          Navigator.pushNamed(context, CreateProcedureView.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
