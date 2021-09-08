<?php

namespace App\Http\Controllers\Admin\Auth;

use App\Models\User;
use App\Models\Admin;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    /**
     * Login method
     * @param Request $request (email | password)
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:255|exists:admins,email',
            'password' => 'required|string|min:6',
        ]);
        if ($validator->fails()) {
            return response(['errors' => $validator->errors()->all()], 422);
        }
        $user = Admin::where('email', $request->email)->first();

        if (Hash::check($request->password, $user->password)) {
            $token = $user->createToken('Admin Password Grant Client')->accessToken;
            $response = [
                'token' => $token,
                'user' => $user,
                'roles' => $user->roles->pluck('name')->all()
            ];
            return response($response, 200);
        } else {
            $response = ["message" => "Email ou mot de password incorrect."];
            return response($response, 422);
        }
    }

    /**
     * Register method
     * @param Request $request (name, email, roles)
     */
    public function register(Request $request)
    {
        $this->validate($request, [
            'name' => 'required',
            'email' => 'email|required|unique:admins',
            'roles' => 'required|array|exists:roles,name',
            'password' => 'required'
        ]);

        $user = new Admin();
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = bcrypt($request->password);
        $user->save();

        $user->assignRole($request->roles);

        return response()->json([
            'message' => "administrateur créé avec succès.",
            'roles' => $request->roles
        ], 200);
    }

    public function logout(Request $request)
    {
    }
}
