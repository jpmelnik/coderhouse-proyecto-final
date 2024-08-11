-- Seleccionar la base de datos para usarla
USE consortium_db;


-- Registro de un Nuevo Gasto Común y Actualización del Fondo de Reserva

BEGIN;

-- Insertar un nuevo gasto común
INSERT INTO common_expenses (condo_id, description, date, amount, category)
VALUES (1, 'Reparación de tuberías', CURDATE(), 800.00, 'Reparaciones');

-- Actualizar el fondo de reserva del condominio
UPDATE condominiums
SET reserve_fund = reserve_fund - 800.00
WHERE condo_id = 1;

-- Verificar si el fondo de reserva es suficiente
DECLARE @new_reserve DECIMAL(10, 2);
SELECT reserve_fund INTO @new_reserve
FROM condominiums
WHERE condo_id = 1;

-- Si el fondo es negativo, revertir la transacción
IF @new_reserve < 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: El fondo de reserva no puede ser negativo.';
ELSE
    COMMIT;
END IF;

-- Pago de Expensas por Parte de un Propietario

BEGIN;

-- Registrar el pago
INSERT INTO payments (expense_id, payment_date, amount, payment_method)
VALUES (10, CURDATE(), 200.00, 'Transferencia');

-- Actualizar el estado de la expensa a "Pagado"
UPDATE expenses
SET payment_status = 'Paid'
WHERE expense_id = 10;

-- Verificar si la expensa fue actualizada correctamente
IF ROW_COUNT() = 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pudo actualizar el estado de la expensa.';
ELSE
    COMMIT;
END IF;

-- Transferencia de Propiedad de una Unidad
BEGIN;

-- Actualizar el propietario de la unidad
UPDATE units
SET owner_id = 2
WHERE unit_id = 5;

-- Verificar que la actualización fue exitosa
IF ROW_COUNT() = 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pudo transferir la propiedad de la unidad.';
ELSE
    COMMIT;
END IF;

-- Registro de una Nueva Reunión y Asignación de Tareas

BEGIN;

-- Registrar la nueva reunión
INSERT INTO meetings (condo_id, meeting_date, agenda)
VALUES (3, '2024-01-15', 'Revisión de presupuestos');

-- Asignar tareas a los propietarios
INSERT INTO tasks (meeting_id, owner_id, description)
VALUES (LAST_INSERT_ID(), 1, 'Preparar informe financiero'),
       (LAST_INSERT_ID(), 2, 'Revisar cotizaciones de mantenimiento');

-- Verificar si las tareas fueron asignadas correctamente
IF ROW_COUNT() < 2 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pudieron asignar todas las tareas.';
ELSE
    COMMIT;
END IF;

--  Registro de una Queja y Creación de una Violación Relacionada

BEGIN;

-- Registrar la queja
INSERT INTO complaints (unit_id, description, date_submitted, status)
VALUES (4, 'Ruidos molestos', CURDATE(), 'Pendiente');

-- Registrar la violación basada en la queja
INSERT INTO violations (unit_id, description, date, penalty, status)
VALUES (4, 'Ruidos molestos', CURDATE(), 50.00, 'Pendiente');

-- Verificar si ambos registros fueron exitosos
IF ROW_COUNT() < 2 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pudieron registrar la queja y la violación.';
ELSE
    COMMIT;
END IF;

-- Contratación de un Servicio de Mantenimiento

BEGIN;

-- Registrar el mantenimiento
INSERT INTO maintenance (condo_id, description, scheduled_date, provider, estimated_cost)
VALUES (2, 'Limpieza de áreas comunes', '2024-01-20', 'CleanCo', 300.00);

-- Actualizar el fondo de reserva del condominio
UPDATE condominiums
SET reserve_fund = reserve_fund - 300.00
WHERE condo_id = 2;

-- Verificar que ambos pasos fueron exitosos
IF ROW_COUNT() < 2 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: No se pudo registrar el mantenimiento y actualizar el fondo de reserva.';
ELSE
    COMMIT;
END IF;
