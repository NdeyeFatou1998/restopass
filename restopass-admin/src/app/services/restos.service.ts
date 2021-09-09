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
  protected _baseUrl: string = "resto/";
  constructor(private http: HttpClient) {
    super();
  }

  cloneResto(resto: Resto): Resto {
    let r = new Resto();
    r.id = resto.id;
    r.name = resto.name;
    r.capacity = resto.capacity;
    r.image_path = resto.image_path;
    r.universite = resto.universite;
    r.universite_id = resto.universite_id;
    r.repreneur_email = resto.repreneur_email;
    r.repreneur_id = resto.repreneur_id;
    r.repreneur_name = resto.repreneur_name;
    return r;
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
        name: resto.name,
        universite_id: resto.universite_id,
        repreneur_id: resto.repreneur_id,
        capacity: resto.capacity ?? 0,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }

  edit(resto: Resto) {
    return this.http.post<Resto>(
      this.api + this.baseUrl + "edit/" + resto.id,
      {
        name: resto.name,
        universite_id: resto.universite_id,
        repreneur_id: resto.repreneur_id,
        capacity: resto.capacity ?? 0,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }

  delete(resto: Resto) {
    return this.http.delete(this.api + this.baseUrl + "delete/" + resto.id, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  freeOr(resto: Resto) {
    return this.http.put<boolean>(
      this.api + this.baseUrl + "status/" + resto.id,
      {
        status: !resto.is_free,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }
}
