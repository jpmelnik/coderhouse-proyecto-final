-- Seleccionar la base de datos para usarla
USE consortium_db;

-- #####################################################
-- Registro de un Nuevo Gasto Común y Actualización del Fondo de Reserva
-- #####################################################

/**
 * Transacción: Registro de un Nuevo Gasto Común y Actualización del Fondo de Reserva
 * 
 * Descripción:
 * Esta transacción inserta un nuevo gasto común para un condominio y actualiza el fondo de reserva.
 * Si el fondo de reserva resulta negativo después de la actualización, la transacción se revierte
 * para mantener la integridad financiera.
 * 
 * Pasos:
 * - Inserta un nuevo gasto común en la tabla `common_expenses`.
 * - Actualiza el fondo de reserva del condominio, restando el monto del gasto.
 * - Verifica si el fondo de reserva es suficiente.
 * - Si el fondo es negativo, revierte la transacción.
 */

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

-- #####################################################
-- Pago de Expensas por Parte de un Propietario
-- #####################################################

/**
 * Transacción: Pago de Expensas por Parte de un Propietario
 * 
 * Descripción:
 * Esta transacción registra el pago de una expensa por parte de un propietario y actualiza 
 * el estado de la expensa a "Pagado". Si la actualización del estado falla, la transacción se revierte.
 * 
 * Pasos:
 * - Inserta un nuevo pago en la tabla `payments`.
 * - Actualiza el estado de la expensa correspondiente a "Pagado".
 * - Verifica si la actualización fue exitosa.
 * - Si la actualización falla, revierte la transacción.
 */

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

-- #####################################################
-- Transferencia de Propiedad de una Unidad
-- #####################################################

/**
 * Transacción: Transferencia de Propiedad de una Unidad
 * 
 * Descripción:
 * Esta transacción actualiza el propietario de una unidad. Si la actualización falla, 
 * la transacción se revierte para garantizar que no se realicen cambios parciales.
 * 
 * Pasos:
 * - Actualiza el propietario de la unidad en la tabla `units`.
 * - Verifica si la actualización fue exitosa.
 * - Si la actualización falla, revierte la transacción.
 */

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

-- #####################################################
-- Registro de una Nueva Reunión y Asignación de Tareas
-- #####################################################

/**
 * Transacción: Registro de una Nueva Reunión y Asignación de Tareas
 * 
 * Descripción:
 * Esta transacción registra una nueva reunión del consorcio y asigna tareas a los propietarios.
 * Si alguna tarea no se asigna correctamente, la transacción se revierte.
 * 
 * Pasos:
 * - Inserta un nuevo registro en la tabla `meetings`.
 * - Asigna tareas a los propietarios en la tabla `tasks`.
 * - Verifica si todas las tareas fueron asignadas correctamente.
 * - Si alguna tarea falla, revierte la transacción.
 */

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

-- #####################################################
-- Registro de una Queja y Creación de una Violación Relacionada
-- #####################################################

/**
 * Transacción: Registro de una Queja y Creación de una Violación Relacionada
 * 
 * Descripción:
 * Esta transacción registra una queja presentada por un propietario o inquilino y, 
 * basándose en la queja, registra una violación a las reglas del consorcio. 
 * Si alguna de las operaciones falla, la transacción se revierte.
 * 
 * Pasos:
 * - Inserta un nuevo registro en la tabla `complaints`.
 * - Inserta un registro correspondiente en la tabla `violations`.
 * - Verifica si ambas inserciones fueron exitosas.
 * - Si alguna falla, revierte la transacción.
 */

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

-- #####################################################
-- Contratación de un Servicio de Mantenimiento
-- #####################################################

/**
 * Transacción: Contratación de un Servicio de Mantenimiento
 * 
 * Descripción:
 * Esta transacción registra la contratación de un servicio de mantenimiento y actualiza 
 * el fondo de reserva del consorcio. Si alguna operación falla, la transacción se revierte.
 * 
 * Pasos:
 * - Inserta un nuevo registro de mantenimiento en la tabla `maintenance`.
 * - Actualiza el fondo de reserva del condominio, restando el costo estimado del mantenimiento.
 * - Verifica si ambas operaciones fueron exitosas.
 * - Si alguna falla, revierte la transacción.
 */

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
