import { ParamsService } from './../../../services/params.service';
import { Component, OnInit } from '@angular/core';
import { Horaire } from 'app/models/horaire';

@Component({
  selector: 'horaires',
  templateUrl: './horaires.component.html',
  styleUrls: ['./horaires.component.css']
})
export class HorairesComponent implements OnInit {
  imgs: string[] = [
    "/assets/img/breakfast.jpg",
    "/assets/img/repas.jpg",
    "/assets/img/dinner.png",
  ]
  horaires: Horaire[];

  isLoad = false;
  editModalVisil= false;
  selectedHoraire: Horaire;
  isConfirmLoading = false;
  constructor(private paramsService: ParamsService) { }

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.isLoad = true;
    this.paramsService.horaires().subscribe({
      next: (response) => {
        this.horaires = response;
        console.log("HORAIRES", this.horaires);
        this.isLoad = false;
      },
      error: errors => {
        this.isLoad = false;
        this.paramsService.notify("top","right", errors.message, "danger");
      }
    })
  }

  horaireImg(horaire: Horaire){
    return this.imgs[horaire.tarif.code - 1];
  }

  openEditModal(horaire: Horaire){
    this.selectedHoraire = horaire;
    this.editModalVisil = true;
  }

  getTime(time: string){
    return time.substr(0, 5);
  }

  editHoraire(){

  }
}
