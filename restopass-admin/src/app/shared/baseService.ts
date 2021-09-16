import { User } from "../models/user";
declare var $: any;
export class BaseService {
  private _host = "http://127.0.0.1:8000/";
  private _api = "http://127.0.0.1:8000/api/";
  protected _baseUrl: string;
  constructor() {}

  isLogIn(): boolean {
    return this.getToken() == null ? false : true;
  }

  get authorizationHeaders() {
    return {
      accept: "application/json",
      "content-type": "application/json",
      authorization: "Bearer " + this.getToken(),
    };
  }

  get guestHeaders() {
    return {
      accept: "application/json",
      "content-type": "application/json",
    };
  }

  getToken(): string {
    return sessionStorage.getItem("token");
  }

  getRoles(): string[] {
    return JSON.parse(sessionStorage.getItem("roles")) as string[];
  }

  get baseUrl(): string {
    return this._baseUrl;
  }

  getUser(): string {
    return sessionStorage.getItem("user");
  }

  setToken(token: string) {
    sessionStorage.setItem("token", token);
  }

  setUser(user: User) {
    sessionStorage.setItem("user", JSON.stringify(user));
  }

  setRoles(roles: string[]) {
    sessionStorage.setItem("roles", JSON.stringify(roles));
  }

  get api(): string {
    return this._api;
  }

  get host(): string {
    return this._host;
  }

  hasRole(role: string): boolean{
    return this.getRoles().some((x) => x === role);
  }

  notify(from: string, align: string, message: string, color: string) {
    $.notify(
      {
        icon: "notifications",
        message: message,
      },
      {
        type: color,
        timer: 1000,
        placement: {
          from: from,
          align: align,
        },
      }
    );
  }

}
