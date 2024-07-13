CREATE OR REPLACE VIEW doctor_schedule_view AS
SELECT
    a.appointment_date,
    a.start_time,
    a.end_time,
    e.first_name AS doctor_first_name,
    e.last_name AS doctor_last_name,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.phone,
    p.email,
    a.status AS appointment_status,
    a.notes AS appointment_notes,
    s.store_id,
    st.full_name AS store_name,
    st.city AS store_city,
    st.state AS store_state
FROM
    appointment a
JOIN
    schedule sch ON a.schedule_id = sch.id_schedule
JOIN
    employee e ON sch.id_employee = e.id_employee
JOIN
    patient p ON a.patient_id = p.id_patient
JOIN
    store st ON e.store_id = st.id_store
WHERE
    e.job_title_id IN (SELECT id_job_title FROM job_title WHERE title = 'Doctor');

COMMENT ON VIEW doctor_schedule_view IS 'View to display doctor schedule, patient information, appointment statuses, and store locations for any given day

-- Примеры использования представления doctor_schedule_view:

-- 1. Получение всех записей за определенный день
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15'';

-- 2. Получение записей конкретного доктора за определенный день
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND doctor_first_name = ''John''
AND doctor_last_name = ''Doe'';

-- 3. Получение всех подтвержденных записей за определенный день
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND appointment_status = ''Confirmed'';

-- 4. Получение всех записей с дополнительными примечаниями за определенный день
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND appointment_notes IS NOT NULL;

-- 5. Фильтрация по магазину (store_name)
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND store_name = ''Main Store'';

-- 6. Фильтрация по городу магазина (store_city)
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND store_city = ''New York'';

-- 7. Фильтрация по штату магазина (store_state)
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND store_state = ''NY'';

-- 8. Комбинированная фильтрация по магазину и статусу записи
SELECT * FROM doctor_schedule_view
WHERE appointment_date = ''2024-07-15''
AND store_name = ''Main Store''
AND appointment_status = ''Confirmed'';

';