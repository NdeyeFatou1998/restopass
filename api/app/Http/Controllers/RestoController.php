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
        $restos = Resto::all();
        $clts = collect($restos)->map(function($resto){
           if($resto->repreneur_id != null) {
               $r = Admin::find($resto->repreneur_id);
                $resto->repreneur_name = $r->name;
                $resto->repreneur_email = $r->email;
           }
           else{
            $resto->repreneur_name = "Non défini";
            $resto->repreneur_email = "Non défini";
           }
           return $resto;
        });
        $repreneurs = Admin::role('repreneur')->get();
        $universites = Universite::all();

        return response()->json([
            'restos' => $clts,
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
        DB::table('restos')->whereId($resto->id)->update($request->all());
        $response = DB::table("restos as R")
            ->where('R.id', $resto->id)
            ->join('admins as A', 'A.id', 'R.repreneur_id')
            ->join("universites as U", "U.id", "R.universite_id")
            ->select("R.*", "A.name as repreneur_name", "A.email as repreneur_email", "U.name as universite")
            ->first();
        return response()->json($response, 200);
    }

    public function tarifs()
    {
        return Tarif::all();
    }

	public function setIsFree(Request $request, Resto $resto){
		$request->validate(['status' => 'required|boolean']);
		$resto->is_free = $request->status;
		$resto->save();
		return response()->json($request->status,200);
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
