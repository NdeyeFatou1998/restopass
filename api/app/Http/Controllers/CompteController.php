<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Compte;
use App\Models\Transfert;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Mail;
use App\Mail\ResetPinMailler;
use App\Models\ResetPassword;
class CompteController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth:api');
    }
    /**
     * Create a new code pin
     */
    public function createPin(Request $request)
    {
        $this->validate($request, ['pin' => 'required|string|min:4|max:4']);

        $compte = Compte::whereUserId(auth()->id())->first();
        $compte->pin = $request->pin;
        $compte->save();

        return response()->json([
            "message" => "Code pin crée avec succès.",
            "code" => 200,
        ], 200);
    }

    /**
     * Modifier son code pin
     */
    public function setPin(Request $request)
    {
        $this->validate($request, [
            'old_pin' => 'required|string|min:4|max:4',
            'new_pin' => 'required|string|min:4|max:4'
        ]);

        $compte = Compte::whereUserId(auth()->id())->first();
        if ($compte->pin == $request->old_pin) {
            $compte->pin = $request->new_pin;
            $compte->save();
            return response()->json([
                'message' => 'Code pin modifié avec succès.',
                'code' => 200
            ], 200);
        } else {
            return response()->json([
                'message' => 'Code pin incorrect.',
                'code' => 422
            ], 422);
        }
    }

    /**
     * Envoyer de l'argent
     */
    public function transfert(Request $request)
    {
        $this->validate($request, [
            'to' => 'required',
            'amount' => 'required|numeric'
        ]);

        $amount = $request->amount;

        $from = Compte::whereUserId(auth()->id())->first();
        $to_user = User::whereMatricule($request->to)->first();
        $to = null;
        if ($to_user != null) {
            $to = Compte::whereUserId($to_user->id)
                ->first();
        } else {
            $to = Compte::whereAccountNum($request->to)
                ->orWhere('account_code', $request->to)
                ->first();
        }
        if ($to == null) {
            return response()->json([
                'message' => 'Le compte n\'existe pas.',
                'code' => 404
            ], 404);
        }
        if ($from->account_num == $to->account_num) {
            return response()->json([
                'message' => 'Impossible de faire un transfert vers son propre compte.',
                'code' => '400'
            ], Response::HTTP_BAD_REQUEST);
        }


        if ($from->pay >= $amount) {
            $from->pay -= $amount;
            $from->save();
            $amount -= $to->debt;
            if ($amount <= 0) {
                // dette reste
                $to->debt = $amount == 0 ? 0 : -$amount;
            } else {
                $to->debt = 0;
                $to->pay += $amount;
            }
            $to->save();

            $transfert = new Transfert();
            $transfert->to_id = $to->id;
            $transfert->from_id = $from->id;
            $transfert->amount = $request->amount;
            $transfert->save();

            return response()->json([
                'message' => 'Vous avez transferé ' . $request->amount . 'FCFA à ' . User::find($to->user_id)->first_name . ' ' . User::find($to->user_id)->last_name . '.',
                'code' => 200
            ], 200);
        } else {
            return response()->json([
                'message' => 'Le solde de votre compte est insuffisant.',
                'code' => 422
            ], 422);
        }
    }

/**
     * Reçevoir son code pin par Email
     */
    public function resetPin(Request $request)
    {
        $this->validate($request, [
            'email' => 'required|string|email|exists:users,email',
        ]);

        $user = User::whereEmail($request->email)->first();

        try {
            Mail::to($user->email)->send(new ResetPinMailler($user, Compte::whereUserId($user->id)->first()->pin));
            return response()->json([
                'message' => 'Un mail vous a été envoyé.',
                'code' => 200
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Une erreur s\'est produit. Merci de réessayer plus tard.',
                'code' => 500
            ], 500);
        }
    }

	public function editPin(Request $request){

	 $this->validate($request, [
            'old_pin' => 'required|min:4|max:4',
            'new_pin' => 'required|min:4|max:4'
        ]);
		$compte = Compte::whereUserId(auth()->id())->first();
		if($request->old_pin == $compte->pin){
			$compte->pin = $request->new_pin;
			$compte->save();
			return response()->json([
                'message' => 'Code pin modifier avec succès.',
                'code' => 200
            ], 200);
		}
		else{
			return response()->json([
                'message' => 'Code pin actuel est incorrecte.',
                'code' => 400
            ], 400);
		}
	}

    /**
     * Voir la liste de envoies
     */
    public function transferts()
    {
        return DB::table("transferts as T")
            ->whereFromId(auth()->id())
            ->orWhere('to_id', auth()->id())
            ->join('users as U', 'U.id', 'T.to_id')
			->join('users as UF', 'UF.id', 'T.from_id')
            ->select("T.amount", 'T.created_at as date', 'U.first_name as to_first_name', 'U.last_name as to_last_name','UF.first_name as from_first_name', 'UF.last_name as from_last_name', 'T.to_id as to_from')
            ->orderBy('T.created_at', 'desc')
            ->get();
    }

    /**
     * Changer sa photo de profile
     */
    public function setImageProfile()
    {
        # code...
    }

    public function setAccountCode()
    {
        $user = auth()->user();
        $compte = Compte::whereUserId(auth()->id())->first();
        $compte->account_code = $user->matricule . time();
        $compte->save();
        return response()->json([
            'user' => $user,
            'compte' => $compte
        ], 200);
    }
}
