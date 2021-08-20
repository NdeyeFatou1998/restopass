import { Resto } from "./../../../models/resto";
import { Component, OnInit } from "@angular/core";
import { RestosService } from "app/services/restos.service";

@Component({
  selector: "resto-list",
  templateUrl: "./resto-list.component.html",
  styleUrls: ["./resto-list.component.css"],
})
export class RestoListComponent implements OnInit {
  restos: Resto[];
  isLoad: boolean = true;
  selectedResto: Resto;
  cloneResto: Resto;
  constructor(private restoService: RestosService) {}

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.isLoad = true;
    this.restoService.findAll().subscribe({
      next: (response: Resto[]) => {
        console.log("RESPONSE", response);
        this.isLoad = false;
      },
      error: (error) => {
        console.log(error);
        this.isLoad = false;
      },
    });
  }
}
