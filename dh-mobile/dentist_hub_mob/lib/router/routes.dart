import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/login_view.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:dentist_hub_mob/views/create_admin_view.dart';
import 'package:dentist_hub_mob/views/create_doctor_view.dart';
import 'package:dentist_hub_mob/views/procedures_view.dart';
import 'package:dentist_hub_mob/views/create_procedure_view.dart';
import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:dentist_hub_mob/views/create_client_view.dart';

var customRoutes = <String, WidgetBuilder>{
  LoginView.id: (_) => const LoginView(),
  HomeView.id: (context) {
    final String? username =
        ModalRoute.of(context)?.settings.arguments as String?;
    return HomeView(username: username ?? '');
  },
  AdminsView.id: (_) => AdminsView(),
  CreateAdminView.id: (context) => CreateAdminView(
        context: context,
      ),
  DoctorsView.id: (_) => DoctorsView(),
  CreateDoctorView.id: (context) => CreateDoctorView(
        context: context,
      ),
  ProceduresView.id: (_) => ProceduresView(),
  CreateProcedureView.id: (context) => CreateProcedureView(
        context: context,
      ),
  ClientsView.id: (_) => ClientsView(),
  CreateClientView.id: (context) => CreateClientView(
        context: context,
      ),
};
