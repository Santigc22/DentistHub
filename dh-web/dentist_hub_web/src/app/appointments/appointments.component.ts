import { Component, OnInit } from '@angular/core';
import { AppointmentsService } from '../appointment.service';

@Component({
  selector: 'app-appointments',
  templateUrl: './appointments.component.html',
  styleUrls: ['./appointments.component.css']
})
export class AppointmentsComponent implements OnInit {
  appointments: any[] = [];

  constructor(private appointmentsService: AppointmentsService) {}

  ngOnInit(): void {
    this.loadAppointments();
  }

  loadAppointments(): void {
    this.appointmentsService.getAppointments().subscribe(
      data => {
        this.appointments = data;
      },
      error => {
        console.error('Error al obtener las citas', error);
      }
    );
  }

  deleteAppointment(id: number): void {
    this.appointmentsService.deleteAppointment(id).subscribe(
      () => {
        this.appointments = this.appointments.filter(appointment => appointment.id !== id);
      },
      error => {
        console.error('Error al borrar la cita', error);
      }
    );
  }

  editAppointment(id: number): void {
    // Aquí puedes manejar la lógica para editar la cita, como abrir un modal con el formulario de edición
    console.log('Editar cita con ID:', id);
  }
}