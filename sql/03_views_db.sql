-- Seleccionar la base de datos para usarla
USE consortium_db;

/**
 * View: unit_details_view
 * 
 * Descripción:
 * Esta vista proporciona un resumen de las unidades, incluyendo información sobre el condominio,
 * el propietario, y los detalles específicos de cada unidad.
 * 
 * Columnas:
 * - unit_id (INT): Identificador único de la unidad.
 * - unit_number (VARCHAR): Número de la unidad dentro del condominio.
 * - unit_type (VARCHAR): Tipo de unidad (por ejemplo, Apartamento, Oficina).
 * - square_meters (DECIMAL): Superficie de la unidad en metros cuadrados.
 * - condo_name (VARCHAR): Nombre del condominio al que pertenece la unidad.
 * - owner_first_name (VARCHAR): Nombre del propietario de la unidad.
 * - owner_last_name (VARCHAR): Apellido del propietario de la unidad.
 * - owner_phone (VARCHAR): Teléfono del propietario.
 * - owner_email (VARCHAR): Correo electrónico del propietario.
 */
CREATE VIEW unit_details_view AS
SELECT 
    u.unit_id,
    u.number AS unit_number,
    u.type AS unit_type,
    u.square_meters,
    c.condo_name,
    o.first_name AS owner_first_name,
    o.last_name AS owner_last_name,
    o.phone AS owner_phone,
    o.email AS owner_email
FROM 
    units u
JOIN 
    condominiums c ON u.condo_id = c.condo_id
JOIN 
    owners o ON u.owner_id = o.owner_id;

/**
 * View: expense_payment_status_view
 * 
 * Descripción:
 * Esta vista muestra los detalles de las expensas de cada unidad, incluyendo el estado de pago
 * y el método de pago utilizado.
 * 
 * Columnas:
 * - expense_id (INT): Identificador único de la expensa.
 * - unit_number (VARCHAR): Número de la unidad a la que se refiere la expensa.
 * - condo_name (VARCHAR): Nombre del condominio al que pertenece la unidad.
 * - month_year (DATE): Mes y año en que se generó la expensa.
 * - total_amount (DECIMAL): Monto total de la expensa.
 * - payment_status (VARCHAR): Estado del pago de la expensa (por ejemplo, Pagado, Pendiente).
 * - payment_method (VARCHAR): Método de pago utilizado para la expensa.
 * - payment_date (DATE): Fecha en la que se realizó el pago.
 */
CREATE VIEW expense_payment_status_view AS
SELECT 
    e.expense_id,
    u.number AS unit_number,
    c.condo_name,
    e.month_year,
    e.total_amount,
    e.payment_status,
    p.payment_method,
    p.payment_date
FROM 
    expenses e
JOIN 
    payments p ON e.expense_id = p.expense_id
JOIN 
    units u ON e.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id;

/**
 * View: upcoming_maintenance_view
 * 
 * Descripción:
 * Esta vista detalla los próximos trabajos de mantenimiento programados para cada condominio,
 * proporcionando una referencia fácil para la administración.
 * 
 * Columnas:
 * - maintenance_id (INT): Identificador único del trabajo de mantenimiento.
 * - condo_name (VARCHAR): Nombre del condominio donde se realizará el mantenimiento.
 * - maintenance_description (VARCHAR): Descripción del trabajo de mantenimiento.
 * - scheduled_date (DATE): Fecha programada para el mantenimiento.
 * - provider (VARCHAR): Nombre del proveedor que realizará el mantenimiento.
 * - estimated_cost (DECIMAL): Costo estimado del mantenimiento.
 */
CREATE VIEW upcoming_maintenance_view AS
SELECT 
    m.maintenance_id,
    c.condo_name,
    m.description AS maintenance_description,
    m.scheduled_date,
    m.provider,
    m.estimated_cost
FROM 
    maintenance m
JOIN 
    condominiums c ON m.condo_id = c.condo_id
WHERE 
    m.scheduled_date >= CURRENT_DATE()
ORDER BY 
    m.scheduled_date;

/**
 * View: service_provider_list_view
 * 
 * Descripción:
 * Esta vista proporciona una lista de proveedores de servicios asociados con los condominios.
 * 
 * Columnas:
 * - provider_id (INT): Identificador único del proveedor de servicios.
 * - provider_name (VARCHAR): Nombre del proveedor de servicios.
 * - provider_phone (VARCHAR): Teléfono de contacto del proveedor.
 * - provider_email (VARCHAR): Correo electrónico de contacto del proveedor.
 * - service_type (VARCHAR): Tipo de servicio que ofrece el proveedor (por ejemplo, Limpieza, Reparaciones).
 */
CREATE VIEW service_provider_list_view AS
SELECT 
    s.provider_id,
    s.name AS provider_name,
    s.phone AS provider_phone,
    s.email AS provider_email,
    s.service_type
FROM 
    service_providers s;

/**
 * View: meeting_agenda_view
 * 
 * Descripción:
 * Esta vista muestra las agendas y minutas de las reuniones de consorcio.
 * 
 * Columnas:
 * - meeting_id (INT): Identificador único de la reunión.
 * - condo_name (VARCHAR): Nombre del condominio donde se celebró la reunión.
 * - meeting_date (DATE): Fecha de la reunión.
 * - agenda (TEXT): Agenda discutida durante la reunión.
 * - minutes (TEXT): Minutas o resúmenes de lo que se decidió durante la reunión.
 */
CREATE VIEW meeting_agenda_view AS
SELECT 
    m.meeting_id,
    c.condo_name,
    m.meeting_date,
    m.agenda,
    m.minutes
FROM 
    meetings m
JOIN 
    condominiums c ON m.condo_id = c.condo_id
ORDER BY 
    m.meeting_date DESC;

/**
 * View: violations_report_view
 * 
 * Descripción:
 * Esta vista muestra un informe de las violaciones a las reglas del consorcio, incluyendo el estado de cada una.
 * 
 * Columnas:
 * - violation_id (INT): Identificador único de la violación.
 * - unit_number (VARCHAR): Número de la unidad que cometió la violación.
 * - condo_name (VARCHAR): Nombre del condominio donde ocurrió la violación.
 * - violation_description (VARCHAR): Descripción de la violación.
 * - date (DATE): Fecha en que se registró la violación.
 * - penalty (DECIMAL): Penalización impuesta por la violación.
 * - status (VARCHAR): Estado de la violación (por ejemplo, Pendiente, Resuelto).
 */
CREATE VIEW violations_report_view AS
SELECT 
    v.violation_id,
    u.number AS unit_number,
    c.condo_name,
    v.description AS violation_description,
    v.date,
    v.penalty,
    v.status
FROM 
    violations v
JOIN 
    units u ON v.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
ORDER BY 
    v.date DESC;

/**
 * View: complaints_status_view
 * 
 * Descripción:
 * Esta vista proporciona un resumen del estado de las quejas presentadas por propietarios o inquilinos.
 * 
 * Columnas:
 * - complaint_id (INT): Identificador único de la queja.
 * - unit_number (VARCHAR): Número de la unidad desde donde se originó la queja.
 * - condo_name (VARCHAR): Nombre del condominio donde se registró la queja.
 * - complaint_description (TEXT): Descripción detallada de la queja.
 * - date_submitted (DATE): Fecha en que se presentó la queja.
 * - status (VARCHAR): Estado actual de la queja (por ejemplo, Pendiente, Resuelto).
 */
CREATE VIEW complaints_status_view AS
SELECT 
    comp.complaint_id,
    u.number AS unit_number,
    c.condo_name,
    comp.description AS complaint_description,
    comp.date_submitted,
    comp.status
FROM 
    complaints comp
JOIN 
    units u ON comp.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
ORDER BY 
    comp.date_submitted DESC;

/**
 * View: event_schedule_view
 * 
 * Descripción:
 * Esta vista proporciona un calendario de eventos organizados en los condominios.
 * 
 * Columnas:
 * - event_id (INT): Identificador único del evento.
 * - condo_name (VARCHAR): Nombre del condominio donde se celebrará el evento.
 * - event_name (VARCHAR): Nombre del evento.
 * - event_date (DATE): Fecha del evento.
 * - event_description (TEXT): Descripción del evento.
 * - organizer (VARCHAR): Nombre de la persona o grupo que organiza el evento.
 */
CREATE VIEW event_schedule_view AS
SELECT 
    e.event_id,
    c.condo_name,
    e.event_name,
    e.event_date,
    e.description AS event_description,
    e.organizer
FROM 
    events e
JOIN 
    condominiums c ON e.condo_id = c.condo_id
ORDER BY 
    e.event_date DESC;

/**
 * View: insurance_policies_view
 * 
 * Descripción:
 * Esta vista muestra un resumen de las pólizas de seguro asociadas a los condominios.
 * 
 * Columnas:
 * - policy_id (INT): Identificador único de la póliza de seguro.
 * - condo_name (VARCHAR): Nombre del condominio cubierto por la póliza de seguro.
 * - provider_name (VARCHAR): Nombre del proveedor de seguros.
 * - policy_number (VARCHAR): Número de la póliza de seguro.
 * - coverage_amount (DECIMAL): Monto de cobertura de la póliza de seguro.
 * - expiration_date (DATE): Fecha de expiración de la póliza de seguro.
 * - contact_phone (VARCHAR): Teléfono de contacto del proveedor de seguros.
 * - contact_email (VARCHAR): Correo electrónico de contacto del proveedor de seguros.
 */
CREATE VIEW insurance_policies_view AS
SELECT 
    i.policy_id,
    c.condo_name,
    i.provider_name,
    i.policy_number,
    i.coverage_amount,
    i.expiration_date,
    i.contact_phone,
    i.contact_email
FROM 
    insurance_policies i
JOIN 
    condominiums c ON i.condo_id = c.condo_id
ORDER BY 
    i.expiration_date DESC;

/**
 * View: condo_violations_summary_view
 * 
 * Descripción:
 * Esta vista proporciona un resumen de las violaciones a las reglas del consorcio para cada condominio.
 * Incluye el número total de violaciones, el monto total de penalizaciones, y un desglose del estado
 * de las violaciones (pendiente o resuelto).
 * 
 * Columnas:
 * - Condominium (VARCHAR): Nombre del condominio.
 * - Total_Violations (INT): Número total de violaciones registradas en el condominio.
 * - Total_Penalties (DECIMAL): Suma total de todas las penalizaciones impuestas por violaciones en el condominio.
 * - Pending_Violations (INT): Número de violaciones que están en estado "Pendiente".
 * - Resolved_Violations (INT): Número de violaciones que han sido "Resueltas".
 * 
 * Agrupación:
 * Los resultados están agrupados por el nombre del condominio y ordenados por el número total de violaciones en orden descendente.
 */

CREATE VIEW condo_violations_summary_view AS
SELECT 
    c.condo_name AS Condominium,
    COUNT(v.violation_id) AS Total_Violations,
    SUM(v.penalty) AS Total_Penalties,
    SUM(CASE WHEN v.status = 'Pendiente' THEN 1 ELSE 0 END) AS Pending_Violations,
    SUM(CASE WHEN v.status = 'Resuelto' THEN 1 ELSE 0 END) AS Resolved_Violations
FROM 
    violations v
JOIN 
    units u ON v.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
GROUP BY 
    c.condo_name
ORDER BY 
    Total_Violations DESC;


/**
 * View: owner_expense_payment_summary_view
 * 
 * Descripción:
 * Esta vista ofrece un resumen detallado de las expensas y pagos realizados por cada propietario.
 * Muestra el nombre del propietario, el número total de unidades que posee, el total de expensas generadas,
 * el total de pagos realizados y el saldo pendiente (si lo hubiera).
 * 
 * Columnas:
 * - Owner_First_Name (VARCHAR): Nombre del propietario.
 * - Owner_Last_Name (VARCHAR): Apellido del propietario.
 * - Total_Units (INT): Número total de unidades que posee el propietario.
 * - Total_Expenses (DECIMAL): Suma total de todas las expensas generadas para las unidades del propietario.
 * - Total_Payments (DECIMAL): Suma total de todos los pagos realizados por el propietario.
 * - Outstanding_Balance (DECIMAL): Saldo pendiente que el propietario aún debe (expensas menos pagos).
 * 
 * Filtros:
 * La vista muestra solo los propietarios que tienen un saldo pendiente.
 * 
 * Agrupación:
 * Los resultados están agrupados por propietario y ordenados por saldo pendiente en orden descendente.
 */

CREATE VIEW owner_expense_payment_summary_view AS
SELECT 
    o.first_name AS Owner_First_Name,
    o.last_name AS Owner_Last_Name,
    COUNT(u.unit_id) AS Total_Units,
    SUM(e.total_amount) AS Total_Expenses,
    SUM(p.amount) AS Total_Payments,
    (SUM(e.total_amount) - SUM(p.amount)) AS Outstanding_Balance
FROM 
    owners o
JOIN 
    units u ON o.owner_id = u.owner_id
JOIN 
    expenses e ON u.unit_id = e.unit_id
LEFT JOIN 
    payments p ON e.expense_id = p.expense_id
GROUP BY 
    o.owner_id
HAVING 
    (SUM(e.total_amount) - SUM(p.amount)) > 0  -- Mostrar solo propietarios con saldo pendiente
ORDER BY 
    Outstanding_Balance DESC;
