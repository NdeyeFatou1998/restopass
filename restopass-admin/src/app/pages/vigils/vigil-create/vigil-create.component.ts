import { Component, Input, OnInit } from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { Resto } from "app/models/resto";
import { Vigil } from "app/models/vigil";
import { RestosService } from "app/services/restos.service";
import { VigilService } from "app/services/vigil.service";
import { NzModalRef } from "ng-zorro-antd/modal";

@Component({
  selector: "vigil-create",
  templateUrl: "./vigil-create.component.html",
  styleUrls: ["./vigil-create.component.css"],
})
export class VigilCreateComponent implements OnInit {
  @Input() restos: Resto[];
  validateForm: FormGroup;
  isLoad: boolean = false;
  vigil: Vigil = new Vigil();

  constructor(
    private fb: FormBuilder,
    private vigilService: VigilService,
    private modal: NzModalRef
  ) {}

  ngOnInit(): void {
    this.validateForm = this.fb.group({
      name: [null, [Validators.required, Validators.min(2)]],
      resto_id: [null, [Validators.required]],
      telephone: [null, [Validators.required]],
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

  createVigil() {
    this.isLoad = true;
    this.vigilService.create(this.vigil).subscribe({
      next: (response) => {
        this.isLoad = false;
        this.destroyModal(response);
        this.vigilService.notify(
          "top",
          "center",
          "Vigil ajouté avec succès.",
          "success"
        );
      },
      error: (errors) => {
        console.log(errors);
        this.destroyModal(null);
        this.vigilService.notify("top", "center", errors.message, "danger");
      },
    });
  }

  destroyModal(data: Vigil|null): void {
    this.modal.destroy(data);
  }
}
