<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Compte;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class EtudiantController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
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
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'matricule' => 'required|unique:users,matricule'
        ]);

        $user = new User();
        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->password = bcrypt('bienvenue');
        $user->matricule = $request->matricule;
        $user->save();

        $account = new Compte;
        $account->account_num = $request->matricule . time();
        $account->account_code = $request->matricule . time();
        $account->user_id = $user->id;
        $account->save();

        //send mail

        return response()->json([
            'message' => 'Étudiant ajouté avec succès.',
            'user' => $user
        ], 200);
    }

    /**
     * Fonction de connexion
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:255|exists:users,email',
            'password' => 'required|string|min:6',
        ]);
        if ($validator->fails()) {
            return response([
                "message" => "Email et mot de passe sont requis.",
                'code' => 422
            ], 422);
        }
        $user = User::where('email', $request->email)->first();

        if (Hash::check($request->password, $user->password)) {
            $token = $user->createToken('User Password Grant Client')->accessToken;
            $response = [
                'token' => $token,
                'user' => $user,
                'compte' => Compte::whereUserId($user->id)->first()
            ];
            return response($response, 200);
        } else {
            return response(
                [
                    "message" => "Email ou mot de password incorrect.",
                    'code' => 422
                ],
                422
            );
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return User::find($id);
    }

    public function user()
    {
        $user = auth()->user();
        $compte = Compte::whereUserId($user->id)->first();
        return response()->json([
            'user' => $user,
            'compte' => $compte
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
