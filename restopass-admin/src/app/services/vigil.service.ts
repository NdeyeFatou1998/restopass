import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Vigil } from "app/models/vigil";
import { VigilResponse } from "app/models/vigil-response";
import { BaseService } from "app/shared/baseService";

@Injectable({
  providedIn: "root",
})
export class VigilService extends BaseService {
  
  protected _baseUrl: string = "vigil/";
  constructor(private http: HttpClient) {
    super();
  }

  findAll() {
    return this.http.get<VigilResponse>(this.api + this.baseUrl, {
      headers: this.authorizationHeaders,
      observe: "body",
    });
  }

  cloneVigil(vigil: Vigil): Vigil {
    let v = new Vigil();
    v.id = vigil.id;
    v.name = vigil.name;
    v.email = vigil.email;
    v.matricule = vigil.matricule;
    v.telephone = vigil.telephone;
    v.resto_id = vigil.resto_id;
    v.resto_name = vigil.resto_name;
    return v;
  }

  edit(vigil: Vigil) {
    return this.http.post<Vigil>(
      this.api + this.baseUrl + "edit/" + vigil.id,
      {
        name: vigil.name,
        telephone: vigil.telephone,
        resto_id: vigil.resto_id,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }

  delete(vigil: Vigil) {
    return this.http.delete<any>(
      this.api + this.baseUrl + "delete/" + vigil.id,
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }

  create(vigil: Vigil) {
    return this.http.post<Vigil>(
      this.api + this.baseUrl + "create",
      {
        name: vigil.name,
        telephone: vigil.telephone,
        resto_id: vigil.resto_id,
      },
      {
        headers: this.authorizationHeaders,
        observe: "body",
      }
    );
  }
}
