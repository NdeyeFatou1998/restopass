import { User } from "./../models/user";
import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { BaseService } from "app/shared/baseService";

@Injectable({
  providedIn: "root",
})
export class UserService extends BaseService {
  

  protected _baseUrl = "admin/";
  constructor(private http: HttpClient) {
    super();
  }

  findRoles() {
    return this.http.get<string[]>(this.api + 'roles', {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  findAll() {
    return this.http.get<User[]>(this.api + this.baseUrl, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  cloneUser(user: User): User{
    let u = new User();
    u.name = user.name;
    u.email = user.email;
    u.id = user.id;
    u.image_path = user.image_path;
    u.roles = this.cloneRoles(user.roles);
    console.log("CLODE USER:", u);
    return u;
  }

  cloneRoles(roles: string[]) {
    let cRoles: string[] = [];
    roles.forEach(r => {
      let c = r;
      cRoles.push(c);
    });
    return cRoles;
  }
  create(user: User) {
    return this.http.post<User>(this.api + this.baseUrl + 'create', {
      name: user.name,
      email: user.email,
      roles: user.roles
    }, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  edit(user: User) {
    return this.http.put<User>(this.api + this.baseUrl + 'edit/' + user.id, {
      name: user.name,
      email: user.email,
      roles: user.roles
    }, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }


  delete(user: User) {
    return this.http.delete(this.api + this.baseUrl + "delete/" + user.id, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }
}
