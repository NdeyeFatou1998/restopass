import { Resto } from './../models/resto';
import { BaseService } from './../shared/baseService';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class RestosService extends BaseService {
  protected _baseUrl: string = "resto";
  constructor(private http: HttpClient) { super();}

  findAll(): Observable<Resto[]>{
    console.log(this.authorizationHeaders);
    
    return this.http.get<Resto[]>(this.api +  this.baseUrl, {
      headers: this.authorizationHeaders,
      observe: "body"
    });
  }
  
}
