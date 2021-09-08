import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { BaseService } from "app/shared/baseService";

@Injectable({
  providedIn: "root",
})
export class UniversiteService extends BaseService {
  protected _baseUrl: string = "resto";
  constructor(private http: HttpClient) {
    super();
  }

  findAll() {
    return this.http.get(this.api + this.baseUrl, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }
}
