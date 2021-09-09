import { User } from "./../../../models/user";
import { Universite } from "./../../../models/universite";
import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { Resto } from "app/models/resto";
import { RestosService } from "app/services/restos.service";
import { NzModalRef } from "ng-zorro-antd/modal";

@Component({
  selector: "resto-create",
  templateUrl: "./resto-create.component.html",
  styleUrls: ["./resto-create.component.css"],
})
export class RestoCreateComponent implements OnInit {
  @Input() univs: Universite[];
  @Input() repreneurs: User[];

  resto: Resto = new Resto();
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

  createResto() {
    console.log("RESTO::::::::::",this.resto)
    this.isLoad = true;
    this.restoService.create(this.resto).subscribe({
      next: (response) => {
        this.isLoad = false;
        this.destroyModal(response);
        this.restoService.notify(
          "top",
          "center",
          "Resto ajouté avec succès.",
          "success"
        );
      },
      error: (errors) => {
        console.log(errors);
        this.destroyModal(null);
        this.restoService.notify("top", "center", errors.message, "danger");
      },
    });
  }

  destroyModal(data: Resto|null): void {
    console.log("DESTROY MODAL");
    this.modal.destroy(data);
  }
}
