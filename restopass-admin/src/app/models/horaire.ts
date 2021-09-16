import { Tarif } from './tarif';
import { Time } from "@angular/common";

export class Horaire {
    id: number;
    open: string;
    close: string;
    tarif: Tarif;
}
