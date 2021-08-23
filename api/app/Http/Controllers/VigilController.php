<?php

namespace App\Http\Controllers;

use DateTime;
use Exception;
use App\Models\Tarif;
use App\Models\Vigil;
use App\Models\Compte;
use App\Models\Payement;
use App\Utils\Constante as C;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class VigilController extends Controller
{
    private const PREFIX_EMAIL = "resto.vigil";
    private const SUFFIX_MAIL = "@restopass.sn";
    private const BASE_MATRICULE = "restopass.vigil";


    public function __construct()
    {
        $this->middleware('is-vigil', ['only' => ['scanner']]);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Vigil::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request, [
            'name' => 'required|string',
            'telephone' => 'required|string'
        ]);

        $num = (count(Vigil::all()) + 1);

        $vigil = new Vigil();
        $vigil->name = $request->name;
        $vigil->telephone = $request->telephone;
        $vigil->email = self::PREFIX_EMAIL . $num . self::SUFFIX_MAIL;
        $vigil->password = bcrypt(static::BASE_MATRICULE);
        $vigil->matricule = "RPV-" . time();
        $vigil->save();

        return response()->json([
            'message' => 'Vigil ajouté avec succès.',
            'vigil' => $vigil
        ], 201);
    }

    /**
     * Fonction de connexion
     */
    public function login(Request $request)
    {
        $this->validate($request, [
            'matricule' => 'required|string|max:255|exists:vigils,matricule',
            'password' => 'required|string|min:6',
        ]);

        $user = Vigil::where('matricule', $request->matricule)->first();
        if ($user->resto_id == null) {
            return response()->json([
                'message' => 'Vous n\'étes affecté à aucun resto pour le moment.',
                'code' => C::NOT_IN_RESTO
            ], 400);
        }
        if (Hash::check($request->password, $user->password)) {
            $token = $user->createToken('Vigil Password Grant Client')->accessToken;
            $response = [
                'token' => $token,
                'user' => DB::table("vigils as U")
                    ->join("restos as R", "R.id", "U.resto_id")
                    ->select("U.name", "U.id", "R.id as resto_id", "U.telephone", "U.matricule", "U.email", "U.image_path", "R.name as resto")
                    ->first(),
                'tarifs' => Tarif::all()
            ];
            return response($response, 200);
        } else {
            return response([
                "message" => "Votre carte n'est pas reconnu.",
                'code' => 400
            ], 400);
        }
    }

    public function logout()
    {
        throw new Exception('Not implemented.');
    }

    public function user()
    {
        return auth()->user();
    }

    public function scanner(Request $request)
    {
        $this->validate($request, [
            'compte' => 'required|string',
            'tarif' => 'required|exists:tarifs,code'
        ]);
        $tarif = Tarif::whereCode($request->tarif)->first();

        $compte = Compte::whereAccountNum($request->compte)
            ->orWhere("account_code", "=", $request->compte)
            ->first();
        if ($compte == null) {
            return response()->json([
                'message' => 'Votre compte est introuvable.',
                'code' => 404
            ], 404);
        }

        if ($compte->pay >= $tarif->price) {
            $compte->pay -= $tarif->price;
            $compte->save();

            $scanner = new Payement();
            $scanner->amount = $tarif->price;
            $scanner->date_time = new DateTime();
            $scanner->resto_id = auth()->user()->resto_id;
            $scanner->vigil_id = auth()->user()->id;
            $scanner->user_id = $compte->user_id;
            $scanner->tarif_id = $tarif->id;
            $scanner->save();

            return response()->json(['message' => 'Ok', 'code' => 200], 200);
        } else {
            return response()->json([
                'message' => 'Votre solde est insuffisant.',
                'code' => 400
            ], 400);
        }
    }

    public function affecterA(Request $request)
    {
        $request->validate([
            'vigil_id' => 'required|string|exists:vigils,id',
            'resto_id' => 'required|string|exists:restos,id'
        ]);

        $vigil = Vigil::find($request->vigil_id);
        $vigil->resto_id = $request->resto_id;
        $vigil->save();

        return response()->json([
            'message' => 'Affectation succès.',
            'code' => 200
        ], 200);
    }
}
