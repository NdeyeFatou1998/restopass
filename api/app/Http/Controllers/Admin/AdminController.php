<?php

namespace App\Http\Controllers\Admin;

use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use App\Http\Controllers\Controller;
use Spatie\Permission\Models\Permission;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('role:super-admin');
    }

    public function repreneurs()
    {
        return Admin::role('repreneur')->get();
    }

    public function index()
    {
        $admins = Admin::with('roles')->get();
        $collection = collect($admins)->map(function ($admin) {
            $n = new Admin();
            $n->name = $admin->name;
            $n->id = $admin->id;
            $n->email = $admin->email;
            $n->image_path  = $admin->image_path;
            $n->roles = $admin->roles->pluck('name')->all();
            return $n;
        });
        return $collection;
    }

    public function roles()
    {
        return Role::all()->pluck('name');
    }

    public function show(Admin $admin)
    {
        return $admin;
    }

    public function create(Request $request)
    {
        $this->validate($request, [
            'name' => 'required',
            'email' => 'email|required|unique:admins',
            'roles' => 'required|array'
        ]);

        $user = new Admin();
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = bcrypt("restopass");
        $user->save();

        $user->assignRole($request->roles);
        $user->roles = $request->roles;
        return response()->json($user, 200);
    }

    public function destroy(Admin $admin)
    {
        $admin->delete();
        return response()->json($admin, 204);;
    }

    public function edit(Request $request, Admin $admin)
    {
        $this->validate($request, [
            'name' => 'required',
            'email' => 'email|required|exists:admins,email',
            'roles' => 'required|array',
        ]);

        DB::table('admins')->whereId($admin->id)->update([
            'name' => $request->name,
            'email' => $request->email,
        ]);

        foreach ($admin->roles as $value) {
            $admin->removeRole($value);
        }
        $admin->assignRole($request->roles);

        $admin = Admin::find($admin->id);

        $r = new Admin();
        $r->name = $admin->name;
        $r->email = $admin->email;
        $r->roles = $admin->getRoleNames();

        return response()->json($r, 200);
    }

    public function givePermissions(Request $request, Admin $admin)
    {
        $admin->givePermissionTo($request->all());
        return response()->json(Admin::find($admin->id), 200);
    }

    public function permissions()
    {
        return Permission::all();
    }
}
