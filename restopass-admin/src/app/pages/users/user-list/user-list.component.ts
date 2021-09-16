import { Component, OnInit } from "@angular/core";
import { User } from "app/models/user";
import { UserService } from "app/services/user.service";
import { NzModalRef, NzModalService } from "ng-zorro-antd/modal";
import { UserCreateComponent } from "../user-create/user-create.component";
import { UserEditComponent } from "../user-edit/user-edit.component";

@Component({
  selector: "user-list",
  templateUrl: "./user-list.component.html",
  styleUrls: ["./user-list.component.css"],
})
export class UserListComponent implements OnInit {
  users: User[];
  newRoles: string[];
  isLoad: boolean = true;
  selectedUser: User;
  deleteRestoRef: NzModalRef;
  deleteLoad: boolean = false;;

  constructor(private userService: UserService,

    private modalService: NzModalService
  ) { }

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.isLoad = true;
    this.userService.findAll().subscribe({
      next: (response: User[]) => {
        this.users = response;
        this.isLoad = false;
      },
      error: (errors) => {
        this.isLoad = false;
        this.userService.notify("top", "right", errors.message, "danger");
      },
    });
  }

  userProfile(user: User) {
    return user.image_path ?? "/assets/img/defaultpp.jpg";
  }

  /**
  * Open create user modal
  */
  openCreateModal() {
    const modal = this.modalService.create({
      nzTitle: "Ajouter un nouveau admin",
      nzContent: UserCreateComponent,
      nzMaskClosable: false,
      nzClosable: false,
    });

    modal.afterClose.subscribe((data: User | null) =>
      this.onCreateResto(data)
    );
  }

  /**
   * Update the list of user
   * @param resto
   */
  onCreateResto(user: User) {
    if (user != null) this.users.unshift(user);
  }


  changeRole(user: User) { }

  openShowModal(user: User) { }
  
  openDeleteModal(user: User) {
    this.selectedUser = user;
    this.deleteRestoRef = this.modalService.confirm({
      nzTitle: "<i>Voulez-vous vraiment supprimé cet utilisateur?</i>",
      nzContent:
        "<b style='color: red;'>Veuillez donner votre confirmation</b>",
      nzOkText: "Oui",
      nzOkType: "primary",
      nzOkDanger: true,
      nzOnOk: () => this.deleteUser(user),
      nzCancelText: "Annuler",
      nzOkLoading: this.deleteLoad,
      nzMaskClosable: false,
      nzClosable: false,
    });
  }

  deleteUser(user: User) {
    this.deleteLoad = false;

    this.userService.delete(user).subscribe({
      next: response => {
        this.deleteLoad = false;
        this.users.splice(this.users.indexOf(this.selectedUser), 1);
        this.userService.notify("top", "right", "Administrateur supprimé", "success");
        this.deleteRestoRef.destroy();
      },
      error: errors => {
        this.deleteLoad = false;
        this.deleteRestoRef.destroy();
        this.userService.notify("top", "right", errors.message, "danger");
      }
    })
  }

  openEditModal(user: User) { 
    this.selectedUser = user;
    const modal = this.modalService.create({
      nzTitle: "Modifier un administrateur",
      nzContent: UserEditComponent,
      nzComponentParams: {
        user: this.userService.cloneUser(user)
      },
      nzMaskClosable: false,
      nzClosable: false,
    });

    modal.afterClose.subscribe((data: User | null) =>
      this.onEditUser(data)
    );
  }

  onEditUser(user: User): void {
    console.log("AFTER EDIT", user);
    
    if (user != null) {
      this.users.splice(this.users.indexOf(this.selectedUser), 1, user);
    }
  }
}
