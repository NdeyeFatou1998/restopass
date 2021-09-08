import { User } from "./../../../models/user";
import { Resto } from "./../../../models/resto";
import { Component, OnInit } from "@angular/core";
import { RestosService } from "app/services/restos.service";
import { Universite } from "app/models/universite";
import { RestoResponse } from "app/models/resto-response";
import { FormBuilder } from "@angular/forms";

@Component({
  selector: "resto-list",
  templateUrl: "./resto-list.component.html",
  styleUrls: ["./resto-list.component.css"],
})
export class RestoListComponent implements OnInit {
  restos: Resto[];
  univs: Universite[];
  repreneurs: User[];
  isLoad: boolean = true;
  selectedResto: Resto;
  cloneResto: Resto;
  createRestoModalVisible: boolean = false;


  constructor(
    private restoService: RestosService,
    private fb: FormBuilder,
  ) {}

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.isLoad = true;
    this.restoService.findAll().subscribe({
      next: (response: RestoResponse) => {
        this.restos = response.restos;
        this.univs = response.universites;
        this.repreneurs = response.repreneurs;
        console.log("UNIVS", this.univs);
        
        this.isLoad = false;
      },
      error: (error) => {
        console.log(error);
        this.isLoad = false;
      },
    });
  }

  onCreateResto(resto: Resto){
    console.log("NEW RESTO IN LIST", resto);
    
    this.restos.push(resto);
  }

  openCreateModal() {
    this.createRestoModalVisible = true;
  }

  closeCreateModal(){
    this.createRestoModalVisible = false;
  }

  
}
