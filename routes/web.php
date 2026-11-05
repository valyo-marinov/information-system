<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
use App\Http\Controllers\LeaveCalendarController;

Route::get('/calendar', [LeaveCalendarController::class, 'index'])->name('calendar.index');
Route::get('/api/leave-events', [LeaveCalendarController::class, 'getEvents'])->name('api.leave-events');