import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Router } from "@angular/router";
import { LoginResponse } from "app/models/login-response";
import { environment } from "environments/environment";
import { BaseService } from "../shared/baseService";

@Injectable({
  providedIn: "root",
})
export class AuthService extends BaseService {
  
  constructor(private router: Router, private http: HttpClient) {
    super();
  }

  alreadyConnect(){
    if(this.isLogIn()) this.router.navigate(['/dashboard']);
  }

  login(username: string, password: string) {
    return this.http.post<LoginResponse>(this.api + "admin/login",
      {
        email: username,
        password: password,
      },
      {
        headers: this.guestHeaders,
        observe: "body",
      }
    );
  }


}
