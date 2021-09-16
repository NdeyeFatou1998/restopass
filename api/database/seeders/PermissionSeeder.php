<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

class PermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Reset cached roles and permissions
        app()[PermissionRegistrar::class]->forgetCachedPermissions();

        $permissions = [
            'edit resto',
            'delete resto',
            'create resto',
            'show resto',

            'edit vigil',
            'delete vigil',
            'create vigil',
            'show vigil',

            'edit admin',
            'delete admin',
            'create admin',
            'show admin',

            'edit univ',
            'delete univ',
            'create univ',
            'show univ',
        ];

        // create permissions
        foreach ($permissions as $value) {
            Permission::create(['guard_name' => 'admin', 'name' => $value]);
        }

        // create roles
        $superAdmin = Role::create(['guard_name' => 'admin', 'name' => 'super-admin']);
        $admin = Role::create(['guard_name' => 'admin','name' => 'admin']);
        $repreneur = Role::create(['guard_name' => 'admin', 'name' => 'repreneur']);

        foreach ($permissions as $value) {
            $superAdmin->givePermissionTo($value);
        }

        $repreneur->givePermissionTo('show resto');

        $admin->givePermissionTo('show resto');

        $admin->givePermissionTo('edit vigil');

        $admin->givePermissionTo('show univ');

        $superAdmin->syncPermissions($permissions);

        $user = \App\Models\Admin::create([
            'id' => 3,
            'name' => 'Super-Admin',
            'email' => 'superadmin@restopass.sn',
            'password' => Hash::make('password')
        ]);
        $user->assignRole($superAdmin);
    }
}
