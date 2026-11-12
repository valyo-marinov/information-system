<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LeaveCalendarController;
use App\Http\Controllers\AuthController;

// Вход и изход
Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// Защитени маршрути
Route::middleware(['auth'])->group(function () {
    Route::get('/', function () {
        return redirect('/calendar');
    });

    Route::get('/calendar', [LeaveCalendarController::class, 'index'])->name('calendar.index');
    Route::get('/leaves/events', [LeaveCalendarController::class, 'getEvents'])->name('leaves.events');
    Route::post('/leaves/store', [LeaveCalendarController::class, 'store'])->name('leaves.store');
    Route::post('/leaves/{id}/status', [LeaveCalendarController::class, 'updateStatus'])->name('leaves.status');
});