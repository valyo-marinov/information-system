<!DOCTYPE html>
<html lang="bg">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>График на отпуските - School HRMS</title>
    
    <!-- Зареждаме FullCalendar през интерент (CDN) -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>

    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
        #calendar { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <h2 style="text-align: center;">График на отсъствията на учителите</h2>
    <div id="calendar"></div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'bg',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek'
                },
                events: '/api/leave-events',
                eventClick: function(info) {
                    alert('Отсъствие: ' + info.event.title);
                }
            });

            calendar.render();
        });
    </script>
</body>
</html>