<?php

namespace App\Http\Controllers\Admin;

use App\Models\Admin;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Http\Controllers\Controller;

class AdminController extends Controller
{
    public function repreneurs()
    {
        return Admin::role('repreneur')->get();
    }
}
