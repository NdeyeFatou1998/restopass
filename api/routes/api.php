<?php

use App\Http\Controllers\Admin\Auth\AuthController;
use App\Http\Controllers\RestoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/**
 * AUTH ROUTES
 */

Route::prefix('admin')->middleware(['guest', 'cors'])->group(function () {
    Route::post('/login', [AuthController::class, 'login'])
        ->name('admin-login');

    Route::post('/register', [AuthController::class, 'register'])
        ->name('admin-register');
});

Route::post('admin/logout', [AuthController::class, 'logout'])
    ->name("admin-logout")
    ->middleware("auth");


Route::prefix('resto')->middleware(['auth:admin'])->group(function () {
    Route::get('/', [RestoController::class, 'index']);
});
