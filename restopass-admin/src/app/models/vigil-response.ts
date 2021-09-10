import { Resto } from "./resto";
import { Vigil } from "./vigil";

export interface VigilResponse {
    vigils: Vigil[];
    restos: Resto[];
}
