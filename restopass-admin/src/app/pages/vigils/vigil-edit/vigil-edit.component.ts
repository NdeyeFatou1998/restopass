import { Component, Input, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Resto } from 'app/models/resto';
import { Vigil } from 'app/models/vigil';
import { VigilService } from 'app/services/vigil.service';
import { NzModalRef } from 'ng-zorro-antd/modal';

@Component({
  selector: 'vigil-edit',
  templateUrl: './vigil-edit.component.html',
  styleUrls: ['./vigil-edit.component.css']
})
export class VigilEditComponent implements OnInit {
  @Input() restos: Resto[];
  @Input()vigil: Vigil;

  validateForm: FormGroup;
  isLoad: boolean = false;

  constructor(
    private fb: FormBuilder,
    private vigilService: VigilService,
    private modal: NzModalRef) { }

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

  editVigil() {
    this.isLoad = true;
    this.vigilService.edit(this.vigil).subscribe({
      next: (response) => {
        this.isLoad = false;
        this.destroyModal(response);
        this.vigilService.notify(
          "top",
          "right",
          "Modification succès.",
          "success"
        );
      },
      error: (errors) => {
        console.log(errors);
        this.destroyModal(null);
        this.vigilService.notify("top", "right", errors.message, "danger");
      },
    });
  }

  destroyModal(data: Vigil|null): void {
    this.modal.destroy(data);
  }

}
