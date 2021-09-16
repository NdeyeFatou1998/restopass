import { Component, Input, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { User } from 'app/models/user';
import { UserService } from 'app/services/user.service';
import { NzModalRef } from 'ng-zorro-antd/modal';

@Component({
  selector: 'user-edit',
  templateUrl: './user-edit.component.html',
  styleUrls: ['./user-edit.component.css']
})
export class UserEditComponent implements OnInit {
  @Input() user: User;
  roles: string[] = [];
  @Input() userRoles: string[];
  validateForm: FormGroup;

  isLoad = false;
  isBtnLoad = false;
  constructor(
    private fb: FormBuilder,
    private userService: UserService,
    private modal: NzModalRef
  ) { }

  ngOnInit(): void {
    console.log("USER ROLES", this.user.roles);
    
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
        console.log("GET ROLES: ", response);
        
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

  editUser() {
    console.log("EDIT USER", this.user);
    
    this.isBtnLoad = true;
    this.userService.edit(this.user).subscribe({
      next: (response) => {
        this.isLoad = false;
        this.destroyModal(response);
        this.userService.notify(
          "top",
          "right",
          "Admin ajouté avec succès.",
          "success"
        );
      },
      error: (errors) => {
        console.log("ERRORS", errors);
        this.destroyModal(null);
        this.userService.notify("top", "right", errors.message, "danger");
      },
    });
  }

  destroyModal(data: User | null): void {
    this.modal.destroy(data);
  }

  compareFn(o1: any, o2: any){
    if(o1 == o2) return true;
    return false;
  }

}
