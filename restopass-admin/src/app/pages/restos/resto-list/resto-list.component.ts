import { User } from "./../../../models/user";
import { Resto } from "./../../../models/resto";
import { Component, OnInit } from "@angular/core";
import { RestosService } from "app/services/restos.service";
import { Universite } from "app/models/universite";
import { RestoResponse } from "app/models/resto-response";
import { FormBuilder } from "@angular/forms";
import { NzModalRef, NzModalService } from "ng-zorro-antd/modal";
import { RestoCreateComponent } from "../resto-create/resto-create.component";
import { RestoEditComponent } from "../resto-edit/resto-edit.component";

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

  createRestoModalVisible: boolean = true;
  currentResto: Resto;
  deleteRestoRef: NzModalRef;
  deleteLoad: boolean = false;
  setRestoLoad: boolean;
  setFreeRestoRef: NzModalRef;
  constructor(
    private restoService: RestosService,
    private modalService: NzModalService
  ) {}

  ngOnInit(): void {
    this.findAll();
  }

  /**
   * Request data from DB
   */
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

  /**
   * Open create resto modal
   */
  openCreateModal() {
    const modal = this.modalService.create({
      nzTitle: "Ajouter un nouveau resto",
      nzContent: RestoCreateComponent,
      nzComponentParams: {
        univs: this.univs,
        repreneurs: this.repreneurs,
      },
      nzMaskClosable: false,
      nzClosable: false,
    });

    modal.afterClose.subscribe((data: Resto | null) =>
      this.onCreateResto(data)
    );
  }

  /**
   * Update the list of restos
   * @param resto new resto
   */
  onCreateResto(resto: Resto) {
    if (resto != null) this.restos.unshift(resto);
  }

  /**
   * Open the edit modal
   * @param resto resto to edit
   */
  openEditModal(resto: Resto) {
    this.selectedResto = resto;
    const modal = this.modalService.create({
      nzTitle: "Modifier le nouveau resto",
      nzContent: RestoEditComponent,
      nzComponentParams: {
        univs: this.univs,
        repreneurs: this.repreneurs,
        resto: this.restoService.cloneResto(resto),
      },
      nzMaskClosable: false,
      nzClosable: false,
    });

    modal.afterClose.subscribe((data: Resto | null) => this.onEditResto(data));
  }

  /**
   * update the list of resto
   * @param resto resto to edit
   */
  onEditResto(resto: Resto): void {
    if (resto != null) {
      this.restos.splice(this.restos.indexOf(this.selectedResto), 1, resto);
    }
  }

  /**
   * On delete btn clicked
   * @param resto resto to delete
   */
  onDeleteResto(resto: Resto) {
    this.deleteRestoRef = this.modalService.confirm({
      nzTitle: "<i>Voulez-vous vraiment supprimé ce resto?</i>",
      nzContent:
        "<b style='color: red;'>Veuillez donner votre confirmation</b>",
      nzOkText: "Oui",
      nzOkType: "primary",
      nzOkDanger: true,
      nzOnOk: () => this.deleteResto(resto),
      nzCancelText: "Annuler",
      nzOkLoading: this.deleteLoad,
      nzMaskClosable: false,
      nzClosable: false,
    });
  }

  /**
   * Delete resto in DB
   * @param resto resto to delete
   */
  deleteResto(resto: Resto): false | void | {} | Promise<false | void | {}> {
    this.selectedResto = resto;
    this.deleteLoad = true;
    this.restoService.delete(resto).subscribe({
      next: (response) => {
        this.restos.splice(this.restos.indexOf(this.selectedResto), 1);
        this.selectedResto = null;
        this.restoService.notify(
          "top",
          "right",
          "Resto supprimé avec succès.",
          "success"
        );
        this.deleteLoad = false;
        this.deleteRestoRef.destroy();
      },
      error: (errors) => {
        this.restoService.notify("top", "right", errors.message, "danger");
        this.deleteLoad = false;
        this.deleteRestoRef.destroy();
      },
    });
  }

  /**
   * Open confirmation modal
   * @param resto the selected resto
   */
  onFreeResto(resto: Resto) {
    this.setFreeRestoRef = this.modalService.confirm({
      nzTitle: "<h3 class='text-danger'>ATTENTION !!!</h3>",
      nzContent:
        "<b style='color: red;'>Voulez-vous vraiment changer l'état du resto?</b>",
      nzOkText: "Oui",
      nzOkType: "primary",
      nzOkDanger: true,
      nzOnOk: () => this.setRestoStatus(resto),
      nzCancelText: "Annuler",
      nzOkLoading: this.setRestoLoad,
      nzMaskClosable: false,
      nzClosable: false,
    });
  }

  /**
   * Set resto's state
   * @param resto resto
   */
  setRestoStatus(resto: Resto) {
    this.selectedResto = resto;
    this.restoService.freeOr(resto).subscribe({
      next: (response) => {
        this.selectedResto.is_free = response;
        this.selectedResto = null;
        this.restoService.notify(
          "top",
          "center",
          "Modification terminées avec succès.",
          "success"
        );
        this.deleteLoad = false;
        this.setFreeRestoRef.destroy();
      },
      error: (errors) => {
        this.selectedResto = null;
        this.restoService.notify("top", "center", errors.message, "success");
        this.deleteLoad = false;
        this.setFreeRestoRef.destroy();
      },
    });
  }
}
