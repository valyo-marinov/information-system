<!DOCTYPE html>
<html lang="bg">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Календар за отпуски</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>
</head>
<body class="bg-light">

@php
    $user = auth()->user();
    $account = $user ? \Illuminate\Support\Facades\DB::table('user_accounts')->where('username', $user->name)->first() : null;
    $isAdmin = $account && strtoupper($account->role) === 'ADMIN';
@endphp

<div class="container mt-4 bg-white p-4 rounded shadow-sm">
    <!-- Горна лента и бутон за Изход -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
        <div>
            <h2 class="mb-0">Календар за заявление на отпуск</h2>
            <small class="text-muted">
                Влезли сте като: <strong>{{ $user->name }}</strong> 
                ({{ $isAdmin ? 'Директор / Администратор' : 'Учител / Служител' }})
            </small>
        </div>
        
        <form method="POST" action="{{ route('logout') }}" class="m-0">
            @csrf
            <button type="submit" class="btn btn-outline-danger btn-sm px-3">Изход</button>
        </form>
    </div>

    <!-- Съобщение при успешно подадена молба -->
    @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    <!-- Бутони за филтриране -->
    <div class="mb-3">
        <div class="btn-group" role="group" id="statusFilterButtons">
            <button type="button" class="btn btn-secondary active" data-status="all">Всички</button>
            <button type="button" class="btn btn-warning text-dark" data-status="pending">Чакащи</button>
            <button type="button" class="btn btn-success" data-status="approved">Одобрени</button>
            <button type="button" class="btn btn-danger" data-status="rejected">Отказани</button>
        </div>
    </div>

    <!-- Календар -->
    <div id="calendar"></div>
</div>

<!-- Модален прозорец за нова молба -->
<div class="modal fade" id="leaveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="{{ route('leaves.store') }}" method="POST">
        @csrf
        <div class="modal-header">
          <h5 class="modal-title">Подаване на молба за отпуск</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="start_date" class="form-label">Начална дата</label>
            <input type="date" class="form-control" id="start_date" name="start_date" required>
          </div>
          <div class="mb-3">
            <label for="end_date" class="form-label">Крайна дата</label>
            <input type="date" class="form-control" id="end_date" name="end_date" required>
          </div>
          <div class="mb-3">
            <label for="reason" class="form-label">Причина</label>
            <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отказ</button>
          <button type="submit" class="btn btn-primary">Запази молбата</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var modalEl = document.getElementById('leaveModal');
    var leaveModal = new bootstrap.Modal(modalEl);
    
    var isAdminOrHr = @json($isAdmin);
    var currentStatusFilter = 'all';

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'bg',
        firstDay: 1,
        selectable: true,
        events: function(fetchInfo, successCallback, failureCallback) {
            fetch("{{ route('leaves.events') }}?status=" + currentStatusFilter, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) throw new Error('HTTP error ' + response.status);
                return response.json();
            })
            .then(data => successCallback(data))
            .catch(error => {
                console.error('Грешка при зареждане:', error);
                failureCallback(error);
            });
        },
        select: function(info) {
            let startDate = info.startStr;
            let endDate = new Date(info.end);
            endDate.setDate(endDate.getDate() - 1);
            let formattedEnd = endDate.toISOString().split('T')[0];

            if (formattedEnd < startDate) {
                formattedEnd = startDate;
            }

            document.getElementById('start_date').value = startDate;
            document.getElementById('end_date').value = formattedEnd;
            document.getElementById('reason').value = '';
            leaveModal.show();
        },
        eventClick: function(info) {
            var event = info.event;
            var status = event.extendedProps.status || 'pending';

            if (isAdminOrHr) {
                var action = prompt(
                    'Молба: ' + event.title + '\nТекущ статус: ' + status + '\n\nНапишете "approved" за одобрение или "rejected" за отказ:'
                );

                if (action === 'approved' || action === 'rejected') {
                    updateStatus(event.id, action);
                }
            } else {
                alert('Молба: ' + event.title + '\nСтатус: ' + status);
            }
        }
    });

    calendar.render();

    // Прихващане на кликовете върху бутоните за филтриране
    document.querySelectorAll('#statusFilterButtons button').forEach(function(button) {
        button.addEventListener('click', function() {
            document.querySelectorAll('#statusFilterButtons button').forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');

            currentStatusFilter = this.getAttribute('data-status');
            calendar.refetchEvents();
        });
    });
});

function updateStatus(eventId, status) {
    fetch("{{ url('/leaves') }}/" + eventId + "/status", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ status: status })
    })
    .then(res => {
        if (!res.ok) throw new Error('Грешка при заявката');
        return res.json();
    })
    .then(data => {
        alert('Статусът е обновен!');
        location.reload();
    })
    .catch(err => alert('Грешка при обновяване!'));
}
</script>

</body>
</html>