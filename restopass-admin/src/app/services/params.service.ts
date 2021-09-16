import { Horaire } from './../models/horaire';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BaseService } from 'app/shared/baseService';

@Injectable({
  providedIn: 'root'
})
export class ParamsService extends BaseService {

  protected _baseUrl = "params/";
  constructor(private http: HttpClient) { super(); }

  horaires() {
    return this.http.get<Horaire[]>(this.api + this.baseUrl + "horaires", {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  statistics(){
    return this.http.get<any>(this.api + this.baseUrl + "statistics", {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }
}
