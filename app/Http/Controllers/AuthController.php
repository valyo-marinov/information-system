<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    // Показва формата за вход
    public function showLogin()
    {
        return view('auth.login');
    }

    // Обработва данните при натискане на "Вход"
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();
            return redirect()->intended('/calendar');
        }

        return back()->withErrors([
            'email' => 'Невалиден имейл или парола.',
        ])->onlyInput('email');
    }

    // Изход от системата
    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/login');
    }
}