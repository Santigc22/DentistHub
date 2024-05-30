import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:dentist_hub_mob/views/procedures_view.dart';

class HomeView extends StatelessWidget {
  static String id = 'home_page_view';
  final String username;

  const HomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username welcome 🦷'),
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
              selected: ModalRoute.of(context)?.settings.name == HomeView.id,
              selectedTileColor: Colors.lightBlue.withOpacity(0.5),
              onTap: () {
                Navigator.pop(context);
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are in the Dentist Hub Home Page',
              style: TextStyle(fontSize: 20, color: Color(0xFFCE93D8)),
            )
          ],
        ),
      ),
    );
  }
}
