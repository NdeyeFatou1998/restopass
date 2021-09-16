import { Component, OnInit } from "@angular/core";
import { Router } from "@angular/router";
import { LoginResponse } from "app/models/login-response";
import { AuthService } from "app/services/auth.service";

@Component({
  selector: "login",
  templateUrl: "./login.component.html",
  styleUrls: ["./login.component.css"],
})
export class LoginComponent implements OnInit {
  isLoad: boolean = false;
  email: string = "";
  password: string = "";
  hasError: boolean = false;
  errorMessage: string;
  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit(): void {
    this.authService.alreadyConnect();
  }

  validate(): boolean {
    if(this.email.length >= 6 && this.password.length >= 6){
      return false;
    }
    return true;
  }

  login() {
    console.log(this.email, this.password);
    this.hasError = false;
    this.isLoad = true;
    this.authService.login(this.email, this.password).subscribe({
      next: (response: LoginResponse) => {
        this.authService.setToken(response.token);
        this.authService.setUser(response.user);
        this.authService.setRoles(response.roles);
        this.router.navigate(['dashboard']);
        this.isLoad = false;
      },
      error: (error) => {
        if(error.status == 422){
          this.authService.notify("top", "center", "Email ou mot de passe incorrect.", "danger");
        }
        else if (error.status == 0){
          this.authService.notify("top", "center", "Merci de vérifier votre connexion internet.", "warning");
        }
        this.isLoad = false;
        this.hasError = true;
      },
    });
  }
}
