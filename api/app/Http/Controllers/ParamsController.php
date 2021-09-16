<?php

namespace App\Http\Controllers;

use App\Models\Tarif;
use App\Models\Horaire;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ParamsController extends Controller
{
    public function index()
    {
        return collect(Horaire::all())->map(function ($horaire) {
            $tarif = Tarif::find($horaire->tarif_id);
            $horaire->tarif = $tarif;
            return $horaire;
        });
    }

    public function statistics()
    {
        $statistics = [];

        // nombre de petit dej dans le mois
        $plats_month['p'] = DB::table('payements')
            ->whereTarifId(Tarif::whereCode(1)->first()->id)
            ->whereYear('created_at', date('Y'))
            ->whereMonth('created_at', date('n'))
            ->get()
            ->count();

        // nombre de repas dans le mois
        $plats_month['r'] = DB::table('payements')
            ->whereTarifId(Tarif::whereCode(2)->first()->id)
            ->whereYear('created_at', date('Y'))
            ->whereMonth('created_at', date('n'))
            ->get()
            ->count();

        // nombre de dinner dans le mois
        $plats_month['d'] = DB::table('payements')
            ->whereTarifId(Tarif::whereCode(3)->first()->id)
            ->whereYear('created_at', date('Y'))
            ->whereMonth('created_at', date('n'))
            ->get()
            ->count();

        $statistics['prd'] = $plats_month;

        $plats_all_month = [];
        for ($i = 1; $i <= 12; $i++) {
            $plats_all_month['p'][] = DB::table("payements")
                ->whereYear('created_at', date('Y'))
                ->whereMonth('created_at', $i)
                ->whereTarifId(Tarif::whereCode(1)->first()->id)
                ->get()
                ->count();
        }

        for ($i = 1; $i <= 12; $i++) {
            $plats_all_month['r'][] = DB::table("payements")
                ->whereTarifId(Tarif::whereCode(2)->first()->id)
                ->whereYear('created_at', date('Y'))
                ->whereMonth('created_at', $i)
                ->get()
                ->count();
        }

        for ($i = 1; $i <= 12; $i++) {
            $plats_all_month['d'][] = DB::table("payements")
                ->whereTarifId(Tarif::whereCode(3)->first()->id)
                ->whereYear('created_at', date('Y'))
                ->whereMonth('created_at', $i)
                ->get()
                ->count();
        }
        $statistics['prd_y'] = $plats_all_month;

        return $statistics;
    }
}
