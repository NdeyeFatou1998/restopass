<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Resto;
use App\Models\Tarif;
use App\Models\Universite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RestoController extends Controller
{

    public function __construct()
    {
    }

    public function index()
    {
        $restos = DB::table("restos as R")
            ->join('admins as A', 'A.id', 'R.repreneur_id')
            ->join("universites as U", "U.id", "R.universite_id")
            ->select("R.*", "A.name as repreneur_name", "A.email as repreneur_email", "U.name as universite")
            ->get();
        $repreneurs = Admin::role('repreneur')->get();
        $universites = Universite::all();

        return response()->json([
            'restos' => $restos,
            'repreneurs' => $repreneurs,
            'universites' => $universites
        ], 200);
    }

    public function show(Resto $resto)
    {
        return $resto;
    }

    public function destroy(Resto $resto)
    {
        $resto->delete();
        return response()->json($resto, 200);
    }

    public function create(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'universite_id' => 'required|exists:universites,id',
            'repreneur_id' => 'required|exists:admins,id',
            'capacity' => 'numeric'
        ]);

        $resto = new Resto;
        $resto->name = $request->name;
        $resto->universite_id = $request->universite_id;
        $resto->repreneur_id = $request->repreneur_id;
        $resto->capacity = $request->capacity ?? 0;
        $resto->save();

        $response = DB::table("restos as R")
            ->where('R.id', $resto->id)
            ->join('admins as A', 'A.id', 'R.repreneur_id')
            ->join("universites as U", "U.id", "R.universite_id")
            ->select("R.*", "A.name as repreneur_name", "A.email as repreneur_email", "U.name as universite")
            ->first();
        return response()->json($response, 200);
    }


    public function edit(Request $request, Resto $resto)
    {
        $resto->update($request->all());
        return response()->json($resto, 200);
    }

    public function tarifs()
    {
        return Tarif::all();
    }

    /**
     * Voir la liste des entrees dans les restos
     */
    public function userPayments()
    {
        return DB::table('payements as P')
            ->whereUserId(auth()->id())
            ->join('restos as R', 'R.id', 'P.resto_id')
            ->join('tarifs as T', 'T.id', 'P.tarif_id')
            ->select('P.amount',  'P.date_time as date', 'R.name as resto', 'T.name as tarif')
            ->orderBy('P.created_at', 'desc')
            ->limit(100)
            ->get();
    }
}
