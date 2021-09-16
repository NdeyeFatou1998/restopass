<?php

namespace App\Http\Controllers;

use App\Models\Tarif;
use App\Models\Horaire;
use Illuminate\Http\Request;

class ParamsController extends Controller
{
    public function index()
    {
       return collect(Horaire::all())->map(function($horaire){
            $tarif = Tarif::find($horaire->tarif_id);
            $horaire->tarif = $tarif;
            return $horaire;
       });
    }
}
