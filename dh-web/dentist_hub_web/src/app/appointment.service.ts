import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AppointmentsService {
  private apiUrl = 'http://192.168.1.46:5000/dentisthub/api';

  constructor(private http: HttpClient) {}

  getAppointments(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/appointments`);
  }

  deleteAppointment(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/appointments/deleteAppointment${id}`);
  }

  editAppointment(id: number, appointmentData: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/appointments/updateAppointment${id}`, appointmentData);
  }
}