import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DoctorService {
  private apiUrl = 'http://192.168.1.46:5000/dentisthub/api';

  constructor(private http: HttpClient) {}

  getDoctors(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/doctors`);
  }

  deleteDoctor(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/doctors/deleteDoctor/${id}`);
  }

  editDoctor(id: number, doctorData: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/doctors/updateDoctor/${id}`, doctorData);
  }
}