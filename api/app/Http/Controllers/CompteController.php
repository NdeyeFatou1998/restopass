<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Compte;
use App\Models\Transfert;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

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
                ->orWhereAccountCode($request->to)
                ->first();
        }
        if ($from->account_num == $to->account_num) {
            return response()->json([
                'message' => 'Impossible de faire un transfert vers son propre compte.',
                'code' => '400'
            ], Response::HTTP_BAD_REQUEST);
        }

        if ($to == null) {
            return response()->json([
                'message' => 'Le compte n\'existe pas.',
                'code' => 404
            ], 422);
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
     * Changer sa photo de profile
     */
    public function setImageProfile()
    {
        # code...
    }
}
