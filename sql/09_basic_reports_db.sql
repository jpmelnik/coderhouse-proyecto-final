-- Seleccionar la base de datos para usarla
USE consortium_db;

-- Reporte: Detalles de las Unidades por Condominio

SELECT 
    u.unit_id,
    u.unit_number,
    u.unit_type,
    u.square_meters,
    c.condo_name,
    o.owner_first_name,
    o.owner_last_name,
    o.owner_phone,
    o.owner_email
FROM 
    unit_details_view u
JOIN 
    condominiums c ON u.condo_id = c.condo_id
JOIN 
    owners o ON u.owner_id = o.owner_id
WHERE 
    c.condo_name = 'Condo One';


-- Reporte: Estado de Pagos de Expensas

SELECT 
    e.unit_number,
    e.condo_name,
    e.month_year,
    e.total_amount,
    e.payment_status,
    e.payment_method,
    e.payment_date
FROM 
    expense_payment_status_view e
WHERE 
    e.condo_name = 'Condo One'
AND 
    e.month_year = '2023-06-01';


-- Reporte: Próximos Mantenimientos

SELECT 
    m.maintenance_description,
    m.scheduled_date,
    m.provider,
    m.estimated_cost,
    c.condo_name
FROM 
    upcoming_maintenance_view m
JOIN 
    condominiums c ON m.condo_id = c.condo_id
WHERE 
    m.scheduled_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);


-- Reporte: Violaciones y Estado

SELECT 
    v.violation_description,
    v.date,
    v.penalty,
    v.status,
    u.unit_number,
    c.condo_name
FROM 
    violations_report_view v
JOIN 
    units u ON v.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
ORDER BY 
    v.date DESC;


-- Reporte: Quejas Pendientes

SELECT 
    comp.complaint_id,
    u.unit_number,
    c.condo_name,
    comp.complaint_description,
    comp.date_submitted
FROM 
    complaints_status_view comp
JOIN 
    units u ON comp.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
WHERE 
    comp.status = 'Pendiente'
ORDER BY 
    comp.date_submitted DESC;


-- Reporte: Cobertura de Seguros por Vencer

SELECT 
    i.policy_number,
    i.provider_name,
    i.coverage_amount,
    i.expiration_date,
    c.condo_name
FROM 
    insurance_policies_view i
JOIN 
    condominiums c ON i.condo_id = c.condo_id
WHERE 
    i.expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 DAY);
