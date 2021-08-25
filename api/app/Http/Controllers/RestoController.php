<?php

namespace App\Http\Controllers;

use App\Models\Resto;
use App\Models\Tarif;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RestoController extends Controller
{

    public function __construct ()
    {

    }

    public function index()
    {
        return Resto::all();
    }

    public function findById($id)
    {
        return Resto::find($id);
    }

    public function destroy($id)
    {
        $resto = DB::table("restos")->whereId($id)->delete();
        return response()->json([
            'success' => true,
            'data' => $resto
        ], 200);
    }

    public function create(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'universite_id' => 'required|exists:universites,id',
        ]);

        $resto = Resto::create($request);
        return response()->json([
            'success' => true,
            'data' => $resto
        ]);
    }


    public function edit(Request $request, $id)
    {
        # code...
    }

	public function tarifs(){
		return Tarif::all();
	}
	
}
