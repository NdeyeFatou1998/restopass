<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Compte;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Mail\ResetPinMailler;
use App\Mail\ResetPWDMailler;
use App\Models\ResetPassword;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
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
                'code' => 400
            ], 400);
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
     * Modifier son mot de passe,
     * @required auth
     */
    public function editPassword(Request $request)
    {
        $this->validate($request, [
            'old_password' => 'required|string',
            'new_password' => 'required|min:6'
        ]);

        $user = User::find(auth()->id());

        if (Hash::check($request->old_password, $user->password)) {
            $user->password = bcrypt($request->new_password);
            $user->save();
            return response()->json([
                'message' => 'Mot de passe modifier avec succès.',
                'code' => 200
            ], 200);
        } else {
            return response()->json([
                'message' => 'Mot de passe incorrecte.',
                'code' => 400
            ], 400);
        }
    }

    /**
     * Mot de passe oublié.
     */
    public function resetPassword(Request $request)
    {
        $this->validate($request, [
            'email' => 'required|string|email|exists:users,email',
        ]);

        $user = User::whereEmail($request->email)->first();
        $code = Str::upper(Str::random(6));

        try {
            Mail::to($user->email)->send(new ResetPWDMailler($user, $code));
            $resetPassword = new ResetPassword();
            $resetPassword->email = $user->email;
            $resetPassword->code = $code;
            $resetPassword->save();
            return response()->json([
                'message' => 'Un mail vous a été envoyé. Utiliser le code pour réinitialiser votre mot de passe.',
                'code' => 200
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Une erreur s\'est produit. Merci de réessayer plus tard.',
                'code' => 500
            ], 500);
        }
    }

    /**
     * Create a new password
     */
    public function newPassword(Request $request)
    {
        $this->validate($request, [
            'email' => 'required|exists:users,email',
            'password' => 'required|string|min:6',
            'code' => 'required|exists:reset_passwords,code'
        ]);

        $code = ResetPassword::where('email', $request->email)
            ->where('code', $request->code)
            ->first();
        if ($code == null) {
            return response()->json([
                'message' => 'Email ou code invalide.',
                'code' => 404
            ], 404);
        } else {
            $user = User::whereEmail($request->email)->first();
            $user->password = bcrypt($request->password);
            $user->save();

			DB::table("reset_passwords")->whereEmail($user->email)->delete();

            $token = $user->createToken('User Password Grant Client')->accessToken;
            $response = [
                'token' => $token,
                'user' => $user,
                'compte' => Compte::whereUserId($user->id)->first()
            ];
            return response($response, 200);
        }
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
