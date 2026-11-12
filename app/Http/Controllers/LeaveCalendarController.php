<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\LeaveRequest;

class LeaveCalendarController extends Controller
{
    public function index()
    {
        return view('calendar.index');
    }

    public function getEvents(Request $request)
    {
        $user = auth()->user();
        
        // Намираме съответния запис в user_accounts по name = username
        $account = DB::table('user_accounts')
            ->where('username', $user->name)
            ->first();

        $isAdmin = $account && strtoupper($account->role) === 'ADMIN';

        $query = LeaveRequest::with('employee');

        // Ако НЕ е ADMIN -> показваме само молбите на неговия employee_id
        if (!$isAdmin) {
            $employeeId = $account ? $account->employee_id : 0;
            $query->where('employee_id', $employeeId);
        }

        // Филтър по статус от бутоните
        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        $leaves = $query->get();

        $events = $leaves->map(function($leave) {
            $emp = $leave->employee;
            $fullName = $emp 
                ? trim("{$emp->first_name} {$emp->surname} {$emp->last_name}") 
                : 'Служител #' . $leave->employee_id;

            $endDate = \Carbon\Carbon::parse($leave->end_date)->addDay()->format('Y-m-d');

            return [
                'id'            => $leave->id,
                'title'         => $fullName . ' - ' . ($leave->reason ?? 'Отпуск'),
                'start'         => $leave->start_date,
                'end'           => $endDate,
                'color'         => $leave->status === 'approved' ? '#198754' : ($leave->status === 'rejected' ? '#dc3545' : '#ffc107'),
                'textColor'     => $leave->status === 'pending' ? '#000000' : '#ffffff',
                'extendedProps' => [
                    'status' => $leave->status
                ]
            ];
        });

        return response()->json($events);
    }

    public function store(Request $request)
    {
        $request->validate([
            'start_date' => 'required|date',
            'end_date'   => 'required|date|after_or_equal:start_date',
            'reason'     => 'required|string|max:500',
        ]);

        $user = auth()->user();
        
        // Взимаме правилния employee_id от user_accounts (4 за Директор, 1 за Н_Стойнов.26)
        $account = DB::table('user_accounts')
            ->where('username', $user->name)
            ->first();

        $leave = new LeaveRequest();
        $leave->employee_id   = $account ? $account->employee_id : 1;
        $leave->leave_type_id = $request->input('leave_type_id', 1);
        $leave->start_date    = $request->start_date;
        $leave->end_date      = $request->end_date;
        $leave->reason        = $request->reason;
        $leave->status        = 'pending';
        $leave->save();

        return redirect()->back()->with('success', 'Молбата е изпратена успешно!');
    }

    public function updateStatus(Request $request, $id)
    {
        $leave = LeaveRequest::findOrFail($id);
        $leave->status = $request->status;
        $leave->save();

        return response()->json(['message' => 'Статусът е обновен успешно!']);
    }
}