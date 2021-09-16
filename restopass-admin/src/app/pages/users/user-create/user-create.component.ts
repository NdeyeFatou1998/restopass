import { Input } from '@angular/core';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { User } from 'app/models/user';
import { UserService } from 'app/services/user.service';
import { NzModalRef } from 'ng-zorro-antd/modal';

@Component({
  selector: 'user-create',
  templateUrl: './user-create.component.html',
  styleUrls: ['./user-create.component.css']
})
export class UserCreateComponent implements OnInit {

  roles: string[] = [];

  validateForm: FormGroup;
  user: User = new User();
  isLoad = false;
  isBtnLoad = false;
  title: string = "Ajouter un nouveau user";
  constructor(
    private fb: FormBuilder,
    private userService: UserService,
    private modal: NzModalRef
  ) { }

  ngOnInit(): void {
    this.findRoles();
    this.validateForm = this.fb.group({
      name: [null, [Validators.required, Validators.min(2)]],
      email: [null, [Validators.required, Validators.email]],
      roles: [null, [Validators.required,]],
    });
  }

  findRoles() {
    this.isLoad = true;
    this.userService.findRoles().subscribe({
      next: (response) => {
        this.roles = response;
        this.isLoad = false;
      },
      error: (errors) => {
        this.isLoad = false;
        this.userService.notify("top", "right", errors.message, "danger");
      }
    })
  }

  submitForm(): void {
    for (const i in this.validateForm.controls) {
      if (this.validateForm.controls.hasOwnProperty(i)) {
        this.validateForm.controls[i].markAsDirty();
        this.validateForm.controls[i].updateValueAndValidity();
      }
    }
  }

  createUser() {
    console.log("NEW USER", this.user);

    this.isBtnLoad = true;
    this.userService.create(this.user).subscribe({
      next: (response) => {
        this.isLoad = false;
        console.log("USER CREATED", response);
        
        this.destroyModal(response);
        this.userService.notify(
          "top",
          "right",
          "Admin ajouté avec succès.",
          "success"
        );
      },
      error: (errors) => {
        console.log(errors);
        this.destroyModal(null);
        this.userService.notify("top", "right", errors.message, "danger");
      },
    });
  }

  destroyModal(data: User | null): void {
    this.modal.destroy(data);
  }
}
