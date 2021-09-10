import { VigilEditComponent } from "./../vigil-edit/vigil-edit.component";
import { Component, OnInit } from "@angular/core";
import { Resto } from "app/models/resto";
import { Vigil } from "app/models/vigil";
import { VigilResponse } from "app/models/vigil-response";
import { RestosService } from "app/services/restos.service";
import { VigilService } from "app/services/vigil.service";
import { NzModalRef, NzModalService } from "ng-zorro-antd/modal";
import { VigilCreateComponent } from "../vigil-create/vigil-create.component";
@Component({
  selector: "vigil-list",
  templateUrl: "./vigil-list.component.html",
  styleUrls: ["./vigil-list.component.css"],
})
export class VigilListComponent implements OnInit {
  vigils: Vigil[];
  restos: Resto[];
  vigilResponse: VigilResponse;

  isLoad: boolean = true;
  selectedVigil: Vigil;
  qrCodeVisibility: boolean = false;
  deleteRestoRef: NzModalRef<unknown, any>;
  deleteLoad: boolean;
  constructor(
    private vigilService: VigilService,
    private restoService: RestosService,
    private modalService: NzModalService
  ) {}

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.isLoad = true;
    this.vigilService.findAll().subscribe({
      next: (response: VigilResponse) => {
        this.vigils = response.vigils;
        this.restos = response.restos;
        this.isLoad = false;
      },
      error: (errors) => {
        console.log(errors);
        this.isLoad = false;
      },
    });
  }

  /**
   * Open create resto modal
   */
  openCreateModal() {
    const ref = this.modalService.create({
      nzTitle: "Ajouter un nouvea vigil",
      nzContent: VigilCreateComponent,
      nzComponentParams: {
        restos: this.restos,
      },
      nzMaskClosable: false,
      nzClosable: false,
    });
    ref.afterClose.subscribe((data: Vigil | null) => this.onCreateVigil(data));
  }

  /**
   * Update the list of restos
   * @param resto new resto
   */
  onCreateVigil(vigil: Vigil) {
    if (vigil != null) this.vigils.unshift(vigil);
  }

  /**
   * Open the edit modal
   * @param resto resto to edit
   */
  openEditModal(vigil: Vigil) {
    this.selectedVigil = vigil;
    const ref = this.modalService.create({
      nzTitle: "Ajouter un nouvea vigil",
      nzContent: VigilEditComponent,
      nzComponentParams: {
        restos: this.restos,
        vigil: this.vigilService.cloneVigil(vigil),
      },
      nzMaskClosable: false,
      nzClosable: false,
    });
    ref.afterClose.subscribe((data: Vigil | null) => this.onEditVigil(data));
  }

  /**
   * update the list of resto
   * @param resto resto to edit
   */
   onEditVigil(vigil: Vigil): void {
     console.log("AFTER UPDATE", vigil,'INDEX OF',this.vigils.indexOf(this.selectedVigil));
     
    if (vigil != null)
      this.vigils.splice(this.vigils.indexOf(this.selectedVigil), 1, vigil);
    this.selectedVigil = null;
  }

  /**
   * On delete btn clicked
   * @param resto resto to delete
   */
  onDeleteResto(vigil: Vigil) {
    this.deleteRestoRef = this.modalService.confirm({
      nzTitle: "<i>Voulez-vous vraiment supprimé ce vigil?</i>",
      nzContent:
        "<b style='color: red;'>Veuillez donner votre confirmation</b>",
      nzOkText: "Oui",
      nzOkType: "primary",
      nzOkDanger: true,
      nzOnOk: () => this.deleteResto(vigil),
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
  deleteResto(vigil: Vigil): false | void | {} | Promise<false | void | {}> {
    this.selectedVigil = vigil;
    this.deleteLoad = true;
    this.vigilService.delete(vigil).subscribe({
      next: (response) => {
        this.vigils.splice(this.vigils.indexOf(this.selectedVigil), 1);
        this.selectedVigil = null;
        this.restoService.notify(
          "top",
          "right",
          "Vigil supprimé avec succès.",
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

  changeVigilResto(vigil: Vigil) {}

  openQrCode(vigil: Vigil) {
    this.qrCodeVisibility = true;
    this.selectedVigil = vigil;
  }

  closeQrCodeModal() {
    this.qrCodeVisibility = false;
  }

  printQrCode() {
    let element = document.getElementById("qrcodeimg");
  }
}
