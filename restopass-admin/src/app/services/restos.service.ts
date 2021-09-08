import { Resto } from "./../models/resto";
import { BaseService } from "./../shared/baseService";
import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { RestoResponse } from "app/models/resto-response";

@Injectable({
  providedIn: "root",
})
export class RestosService extends BaseService {
  protected _baseUrl: string = "resto";
  constructor(private http: HttpClient) {
    super();
  }

  findAll(): Observable<RestoResponse> {
    return this.http.get<RestoResponse>(this.api + this.baseUrl, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  create(resto: Resto) {
    return this.http.post<Resto>(
      this.api + this.baseUrl + "create",
      {
        'name': resto.name,
        'universite_id': resto.universite_id,
        'repreneur_id': resto.repreneur_id,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }
}
