-- Seleccionar la base de datos para usarla
USE consortium_db;

/**
 * Procedure: add_common_expense_and_update_reserve
 * 
 * Descripción:
 * Este procedimiento almacena un nuevo gasto común para un condominio específico y actualiza 
 * el fondo de reserva del consorcio restando el monto del gasto. Si el fondo de reserva queda 
 * en negativo, se emite una advertencia.
 * 
 * Parámetros de Entrada:
 * - condo_id_param (INT): ID del condominio donde se realiza el gasto.
 * - description_param (VARCHAR): Descripción del gasto común.
 * - date_param (DATE): Fecha en la que se realizó el gasto.
 * - amount_param (DECIMAL): Monto del gasto común.
 * - category_param (VARCHAR): Categoría del gasto.
 * 
 * Comportamiento:
 * - Inserta un nuevo registro en la tabla `common_expenses`.
 * - Actualiza el fondo de reserva del condominio restando el monto del gasto.
 * - Verifica si el fondo de reserva es negativo y emite una advertencia si es necesario.
 */
CREATE PROCEDURE add_common_expense_and_update_reserve(
    IN condo_id_param INT,
    IN description_param VARCHAR(255),
    IN date_param DATE,
    IN amount_param DECIMAL(10, 2),
    IN category_param VARCHAR(50)
)
BEGIN
    -- Insertar el nuevo gasto común
    INSERT INTO common_expenses (condo_id, description, date, amount, category)
    VALUES (condo_id_param, description_param, date_param, amount_param, category_param);
    
    -- Actualizar el fondo de reserva del consorcio, restando el monto del gasto
    UPDATE condominiums
    SET reserve_fund = reserve_fund - amount_param
    WHERE condo_id = condo_id_param;
    
    -- Verificar que el fondo de reserva no sea negativo y emitir una advertencia si es necesario
    SELECT reserve_fund INTO @new_reserve
    FROM condominiums
    WHERE condo_id = condo_id_param;

    IF @new_reserve < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Advertencia: El fondo de reserva ha quedado en negativo.';
    END IF;

END //

DELIMITER ;

/**
 * Procedure: get_owner_total_expenses
 * 
 * Descripción:
 * Este procedimiento calcula el total de expensas pagadas por un propietario para todas las unidades
 * que posee en un año específico.
 * 
 * Parámetros de Entrada:
 * - owner_id_param (INT): ID del propietario para el cual se calcularán las expensas.
 * - year_param (YEAR): Año en el que se buscarán las expensas pagadas.
 * 
 * Parámetro de Salida:
 * - total_expenses (DECIMAL): Monto total de expensas pagadas por el propietario en el año especificado.
 * 
 * Comportamiento:
 * - Calcula y devuelve el total de expensas pagadas por el propietario para todas sus unidades en el año especificado.
 * - Si no hay registros, devuelve 0.
 */
CREATE PROCEDURE get_owner_total_expenses(
    IN owner_id_param INT, 
    IN year_param YEAR, 
    OUT total_expenses DECIMAL(10, 2)
)
BEGIN
    -- Calcular el total de expensas pagadas por el propietario en el año especificado
    SELECT SUM(p.amount) INTO total_expenses
    FROM payments p
    JOIN expenses e ON p.expense_id = e.expense_id
    JOIN units u ON e.unit_id = u.unit_id
    WHERE u.owner_id = owner_id_param 
    AND YEAR(e.month_year) = year_param 
    AND e.payment_status = 'Paid';

    -- Si no hay registros, devolver 0
    IF total_expenses IS NULL THEN
        SET total_expenses = 0;
    END IF;
END //

DELIMITER ;

/**
 * Procedure: get_condo_maintenance_summary
 * 
 * Descripción:
 * Este procedimiento proporciona un resumen de los gastos de mantenimiento realizados en un condominio
 * durante un año específico.
 * 
 * Parámetros de Entrada:
 * - condo_id_param (INT): ID del condominio para el cual se generará el resumen de mantenimiento.
 * - year_param (YEAR): Año en el que se buscarán los mantenimientos realizados.
 * 
 * Comportamiento:
 * - Genera un resumen de los trabajos de mantenimiento realizados, incluyendo la descripción,
 *   fecha programada, proveedor de servicios, costo estimado, y la cantidad pagada.
 */
CREATE PROCEDURE get_condo_maintenance_summary(
    IN condo_id_param INT, 
    IN year_param YEAR
)
BEGIN
    -- Generar el resumen de mantenimiento
    SELECT 
        m.description AS Maintenance_Description,
        m.scheduled_date AS Scheduled_Date,
        m.provider AS Service_Provider,
        m.estimated_cost AS Estimated_Cost,
        IFNULL(SUM(p.amount), 0) AS Amount_Paid
    FROM maintenance m
    LEFT JOIN payments p ON m.maintenance_id = p.expense_id
    WHERE m.condo_id = condo_id_param 
    AND YEAR(m.scheduled_date) = year_param
    GROUP BY m.maintenance_id;
END //

DELIMITER ;

/**
 * Procedure: record_violation
 * 
 * Descripción:
 * Este procedimiento registra una nueva violación a las reglas del consorcio y actualiza el estado correspondiente.
 * 
 * Parámetros de Entrada:
 * - unit_id_param (INT): ID de la unidad que cometió la violación.
 * - description_param (VARCHAR): Descripción de la violación.
 * - date_param (DATE): Fecha en la que se registró la violación.
 * - penalty_param (DECIMAL): Penalización impuesta por la violación.
 * - status_param (VARCHAR): Estado de la violación (por ejemplo, Pendiente, Resuelto).
 * 
 * Comportamiento:
 * - Inserta un nuevo registro de violación en la tabla `violations`.
 * - Actualiza el estado de la violación en caso de que ya exista.
 */
CREATE PROCEDURE record_violation(
    IN unit_id_param INT,
    IN description_param VARCHAR(255),
    IN date_param DATE,
    IN penalty_param DECIMAL(10, 2),
    IN status_param VARCHAR(50)
)
BEGIN
    -- Insertar la nueva violación en la tabla `violations`
    INSERT INTO violations (unit_id, description, date, penalty, status)
    VALUES (unit_id_param, description_param, date_param, penalty_param, status_param);
    
    -- Actualizar el estado de la violación si es necesario
    UPDATE violations
    SET status = status_param
    WHERE unit_id = unit_id_param
    AND description = description_param
    AND date = date_param;
END //

DELIMITER ;

/**
 * Procedure: resolve_complaint
 * 
 * Descripción:
 * Este procedimiento marca una queja como resuelta y actualiza el estado en la base de datos.
 * 
 * Parámetros de Entrada:
 * - complaint_id_param (INT): ID de la queja que se va a marcar como resuelta.
 * 
 * Comportamiento:
 * - Actualiza el estado de la queja a 'Resuelto' en la tabla `complaints`.
 */
CREATE PROCEDURE resolve_complaint(
    IN complaint_id_param INT
)
BEGIN
    -- Actualizar el estado de la queja a 'Resuelto'
    UPDATE complaints
    SET status = 'Resuelto'
    WHERE complaint_id = complaint_id_param;
END //

DELIMITER ;
