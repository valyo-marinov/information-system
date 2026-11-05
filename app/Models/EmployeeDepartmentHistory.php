<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EmployeeDepartmentHistory extends Model
{
    use HasFactory;

    protected $table = 'employee_department_history';

    protected $fillable = [
        'employee_id',
        'department_id',
        'start_date',
        'end_date',
        'reason',
    ];

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    public function department()
    {
        return $this->belongsTo(Department::class);
    }
}