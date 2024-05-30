import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ClientService {
  private apiUrl = 'http://192.168.1.46:5000/dentisthub/api';

  constructor(private http: HttpClient) {}

  getClients(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/clients`);
  }

  deleteClient(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/clients/deleteClient/${id}`);
  }

  editClient(id: number, clientData: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/clients/updateClient/${id}`, clientData);
  }
}