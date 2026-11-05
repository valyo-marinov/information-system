<?php

namespace App\Http\Controllers;

use App\Models\LeaveRequest;
use Illuminate\Http\Request;

class LeaveCalendarController extends Controller
{
    public function index()
    {
        return view('calendar.index');
    }

    public function getEvents()
    {
        $leaves = LeaveRequest::with(['employee', 'leaveType'])->get();

        $events = $leaves->map(function ($leave) {
            // Задаваме цвят според статуса на молбата за отпуск
            $color = match($leave->status) {
                'APPROVED' => '#28a745', // Зелено (Одобрен)
                'PENDING'  => '#ffc107', // Жълто (В чакане)
                'REJECTED' => '#dc3545', // Червено (Отказан)
                default    => '#6c757d'
            };

            return [
                'id'    => $leave->id,
                'title' => $leave->employee->first_name . ' ' . $leave->employee->last_name . ' (' . $leave->leaveType->name . ')',
                'start' => $leave->start_date,
                'end'   => date('Y-m-d', strtotime($leave->end_date . ' +1 day')),
                'color' => $color,
            ];
        });

        return response()->json($events);
    }
}