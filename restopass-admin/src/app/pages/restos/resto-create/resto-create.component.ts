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
  @Input() isVisible: boolean;
  @Input() univs: Universite[];
  @Input() repreneurs: User[];
  @Output() create: EventEmitter<Resto> = new EventEmitter();
  @Output() close: EventEmitter<boolean> = new EventEmitter();

  resto: Resto = new Resto();
  validateForm: FormGroup;
  isLoad: boolean = false;

  constructor(
    private fb: FormBuilder,
    private restoService: RestosService,
  ) {}

  ngOnInit(): void {
    this.validateForm = this.fb.group({
      name: [null, [Validators.required, Validators.min(2)]],
      universite: [null, [Validators.required]],
      repreneur: [null, [Validators.required]],
    });
  }

  submitCreateForm(): void {
    for (const i in this.validateForm.controls) {
      if (this.validateForm.controls.hasOwnProperty(i)) {
        this.validateForm.controls[i].markAsDirty();
        this.validateForm.controls[i].updateValueAndValidity();
      }
    }
    console.log(this.validateForm.value);
  }

  createResto() {
    this.isLoad = true;
    this.restoService.create(this.resto).subscribe({
      next: response => {
        this.isLoad = false;
        this.create.emit(response);
        this.closeModal();
        this.restoService.notify("top", "center", "Resto ajouté avec succès.", "success");
      },
      error: errors => {
        console.log(errors);
        this.isVisible = false
        this.restoService.notify("top", "center", errors, "success");
      }
    });
  }

  closeModal() {
    this.isVisible = false;
    this.close.emit(true);
  }

}
