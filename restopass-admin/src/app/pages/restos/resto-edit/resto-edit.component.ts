import { Component, Input, OnInit } from "@angular/core";
import { FormGroup, FormBuilder, Validators } from "@angular/forms";
import { Resto } from "app/models/resto";
import { Universite } from "app/models/universite";
import { User } from "app/models/user";
import { RestosService } from "app/services/restos.service";
import { NzModalRef } from "ng-zorro-antd/modal";

@Component({
  selector: "resto-edit",
  templateUrl: "./resto-edit.component.html",
  styleUrls: ["./resto-edit.component.css"],
})
export class RestoEditComponent implements OnInit {
  @Input() univs: Universite[];
  @Input() repreneurs: User[];
  @Input() resto: Resto;

  validateForm: FormGroup;
  isLoad: boolean = false;
  title: string = "Ajouter un nouveau resto";
  constructor(
    private fb: FormBuilder,
    private restoService: RestosService,
    private modal: NzModalRef
  ) {}

  ngOnInit(): void {
    this.validateForm = this.fb.group({
      name: [null, [Validators.required, Validators.min(2)]],
      universite: [null, [Validators.required]],
      repreneur: [null, [Validators.required]],
      capacity: [0, [Validators.required]],
    });
  }

  submitForm(): void {
    for (const i in this.validateForm.controls) {
      if (this.validateForm.controls.hasOwnProperty(i)) {
        this.validateForm.controls[i].markAsDirty();
        this.validateForm.controls[i].updateValueAndValidity();
      }
    }
  }

  destroyModal(data: Resto | null): void {
    console.log("DESTROY MODAL");
    this.modal.destroy(data);
  }

  editResto() {
    this.isLoad = true;
    this.restoService.edit(this.resto).subscribe({
      next: (response) => {
        this.isLoad = false;
        this.restoService.notify(
          "top",
          "center",
          "Resto modifié avec succès.",
          "success"
        );
        this.destroyModal(response);
      },
      error: (errors) => {
        this.isLoad = false;
        this.restoService.notify("top", "center", errors.message, "danger");
        this.destroyModal(null);
      },
    });
  }
}
