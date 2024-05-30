import { Component, OnInit } from '@angular/core';
import { ClientService } from '../client.service';

@Component({
  selector: 'app-clients',
  templateUrl: './clients.component.html',
  styleUrls: ['./clients.component.css']
})
export class ClientsComponent implements OnInit {
  clients: any[] = [];

  constructor(private clientsService: ClientService) {}

  ngOnInit(): void {
    this.loadClients();
  }

  loadClients(): void {
    this.clientsService.getClients().subscribe(
      data => {
        this.clients = data;
      },
      error => {
        console.error('Error al obtener los clientes', error);
      }
    );
  }

  deleteClient(id: number): void {
    this.clientsService.deleteClient(id).subscribe(
      () => {
        this.clients = this.clients.filter(client => client.id !== id);
      },
      error => {
        console.error('Error al borrar el cliente', error);
      }
    );
  }

  editClient(id: number): void {
    console.log('Editar cliente con ID:', id);
  }
}