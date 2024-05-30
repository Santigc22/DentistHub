import 'package:dentist_hub_mob/views/create_doctor_view.dart';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';
import 'package:dentist_hub_mob/function.dart';
import 'package:dentist_hub_mob/views/edit_doctor_view.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:dentist_hub_mob/views/procedures_view.dart';
import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:http/http.dart' as http;

class DoctorsView extends StatefulWidget {
  static String id = 'doctors_view';

  @override
  _DoctorsViewState createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  final String serverIp = '192.168.1.46';
  final String GETDoctorsURL =
      'http://192.168.1.46:5000/dentisthub/api/doctors';
  late List<dynamic> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchData(GETDoctorsURL).then((data) {
      if (data != null) {
        setState(() {
          doctors = data;
        });
      }
    });
  }

  Future<void> deleteDoctor(String id) async {
    final String deleteDoctorURL =
        'http://192.168.1.46:5000/dentisthub/api/doctors/deleteDoctor/$id';
    try {
      final http.Response response =
          await http.delete(Uri.parse(deleteDoctorURL));

      if (response.statusCode == 200) {
        setState(() {
          doctors.removeWhere((doctor) => doctor['id_doctor'] == id);
        });
      } else {
        print('Error al eliminar doctor: ${response.body}');
      }
    } catch (e) {
      print('Error de red al eliminar doctor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors 👨‍⚕️'),
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
              selected: ModalRoute.of(context)?.settings.name == DoctorsView.id,
              selectedTileColor: Colors.lightBlue.withOpacity(0.5),
              onTap: () {
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
                'Doctors',
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
                rows: doctors.map((doctor) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(doctor['name'] ?? '')),
                      DataCell(Text(doctor['username'] ?? '')),
                      DataCell(Text(doctor['cc'].toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditDoctorView(doctor: doctor),
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
                                          'Are you sure you want to delete this doctor?'),
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
                                deleteDoctor(doctor['id_doctor']);
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
          Navigator.pushNamed(context, CreateDoctorView.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
