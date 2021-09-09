import { Resto } from "./resto";
import { Universite } from "./universite";
import { User } from "./user";

export interface RestoResponse{
    universites: Universite[];
    restos: Resto[];
    repreneurs: User[];
}
