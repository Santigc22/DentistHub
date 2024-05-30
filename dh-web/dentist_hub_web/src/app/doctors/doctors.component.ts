import { Component, OnInit } from '@angular/core';
import { DoctorService } from '../doctor.service';

@Component({
  selector: 'app-doctors',
  templateUrl: './doctors.component.html',
  styleUrls: ['./doctors.component.css']
})
export class DoctorsComponent implements OnInit {
  doctors: any[] = [];

  constructor(private doctorsService: DoctorService) {}

  ngOnInit(): void {
    this.loadDoctors();
  }

  loadDoctors(): void {
    this.doctorsService.getDoctors().subscribe(
      data => {
        this.doctors = data;
      },
      error => {
        console.error('Error al obtener los doctores', error);
      }
    );
  }

  deleteDoctor(id: number): void {
    this.doctorsService.deleteDoctor(id).subscribe(
      () => {
        this.doctors = this.doctors.filter(doctor => doctor.id !== id);
      },
      error => {
        console.error('Error al borrar el doctor', error);
      }
    );
  }

  editDoctor(id: number): void {
    console.log('Editar doctor con ID:', id);
  }
}