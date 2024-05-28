import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';
import 'package:dentist_hub_mob/function.dart';
import 'package:dentist_hub_mob/views/create_admin_view.dart';
import 'package:dentist_hub_mob/views/edit_admin_view.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AdminsView extends StatefulWidget {
  static String id = 'admins_view';

  @override
  _AdminsViewState createState() => _AdminsViewState();
}

class _AdminsViewState extends State<AdminsView> {
  final String serverIp = '192.168.1.46';
  final String GETAdminsURL = 'http://192.168.1.46:5000/dentisthub/api/admins';
  late List<dynamic> admins = [];

  @override
  void initState() {
    super.initState();
    fetchData(GETAdminsURL).then((data) {
      if (data != null) {
        setState(() {
          admins = data;
        });
      }
    });
  }

  Future<void> deleteAdmin(String id) async {
    final String deleteAdminURL =
        'http://192.168.1.46:5000/dentisthub/api/admins/deleteAdmin/$id';
    try {
      final http.Response response =
          await http.delete(Uri.parse(deleteAdminURL));

      if (response.statusCode == 200) {
        setState(() {
          admins.removeWhere((admin) => admin['id_admin'] == id);
        });
      } else {
        print('Error al eliminar admin: ${response.body}');
      }
    } catch (e) {
      print('Error de red al eliminar admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admins'),
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
              selected: ModalRoute.of(context)?.settings.name == AdminsView.id,
              selectedTileColor: Colors.lightBlue.withOpacity(0.5),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != AdminsView.id) {
                  Navigator.pushReplacementNamed(context, AdminsView.id);
                }
              },
            ),
            ListTile(
              title: const Text('Clients'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Procedures'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Doctors'),
              onTap: () {
                Navigator.pop(context);
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
                'Admins',
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
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('CC')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: admins.map((admin) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(admin['name'] ?? '')),
                      DataCell(Text(admin['username'] ?? '')),
                      DataCell(Text(admin['cc'].toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditAdminView(admin: admin),
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
                                          'Are you sure you want to delete this admin?'),
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
                                deleteAdmin(admin['id_admin']);
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
          Navigator.pushNamed(context, CreateAdminView.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
