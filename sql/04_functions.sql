-- Seleccionar la base de datos para usarla
USE consortium_db;

DELIMITER //

/**
 * Calculate the total expenses paid by an owner for all units they own in a specific year.
 * 
 * @param {INT} owner_id_param - The ID of the owner for whom to calculate total expenses.
 * @param {YEAR} year_param - The year in which to search for paid expenses.
 * @returns {DECIMAL(10, 2)} - The total amount of expenses paid by the owner in the specified year. Returns 0 if no records are found.
 */

CREATE FUNCTION get_total_expenses_for_owner(
    owner_id_param INT, 
    year_param YEAR
) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_expenses DECIMAL(10, 2);

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

    RETURN total_expenses;
END //

DELIMITER ;

DELIMITER //

/**
 * Calculate the remaining reserve fund of a condominium after deducting all common expenses.
 * 
 * @param {INT} condo_id_param - The ID of the condominium for which to calculate the remaining reserve fund.
 * @returns {DECIMAL(10, 2)} - The remaining amount of the reserve fund. Returns the full reserve fund if no common expenses are found.
 */

CREATE FUNCTION calculate_remaining_reserve_fund(
    condo_id_param INT
) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE remaining_fund DECIMAL(10, 2);

    -- Calcular el fondo de reserva restante
    SELECT reserve_fund - SUM(amount) INTO remaining_fund
    FROM condominiums c
    JOIN common_expenses ce ON c.condo_id = ce.condo_id
    WHERE c.condo_id = condo_id_param;

    -- Si no hay gastos comunes, devolver el fondo de reserva completo
    IF remaining_fund IS NULL THEN
        SELECT reserve_fund INTO remaining_fund
        FROM condominiums
        WHERE condo_id = condo_id_param;
    END IF;

    RETURN remaining_fund;
END //

DELIMITER ;

DELIMITER //

/**
 * Calculate the total overdue payments for a specific unit.
 * 
 * @param {INT} unit_id_param - The ID of the unit for which to calculate overdue payments.
 * @returns {DECIMAL(10, 2)} - The total amount of overdue payments. Returns 0 if there are no overdue payments.
 */

CREATE FUNCTION get_overdue_payments_for_unit(
    unit_id_param INT
) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE overdue_amount DECIMAL(10, 2);

    -- Calcular el total de pagos atrasados
    SELECT SUM(e.total_amount) INTO overdue_amount
    FROM expenses e
    WHERE e.unit_id = unit_id_param
    AND e.payment_status = 'Pending';

    -- Si no hay pagos atrasados, devolver 0
    IF overdue_amount IS NULL THEN
        SET overdue_amount = 0;
    END IF;

    RETURN overdue_amount;
END //

DELIMITER ;

DELIMITER //

/**
 * Calculate the total number of units in a specific condominium.
 * 
 * @param {INT} condo_id_param - The ID of the condominium for which to count the units.
 * @returns {INT} - The total number of units in the specified condominium. Returns 0 if no units are found.
 */

CREATE FUNCTION get_total_units_in_condo(
    condo_id_param INT
) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_units INT;

    -- Contar el número total de unidades en el condominio especificado
    SELECT COUNT(*) INTO total_units
    FROM units
    WHERE condo_id = condo_id_param;

    RETURN total_units;
END //

DELIMITER ;

DELIMITER //

/**
 * Retrieve the minutes of the latest meeting held in a specific condominium.
 * 
 * @param {INT} condo_id_param - The ID of the condominium for which to retrieve the latest meeting minutes.
 * @returns {TEXT} - The minutes of the latest meeting. Returns 'No meeting minutes available.' if no meetings are found.
 */

CREATE FUNCTION get_latest_meeting_minutes(
    condo_id_param INT
) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE latest_minutes TEXT;

    -- Obtener las minutas de la última reunión
    SELECT minutes INTO latest_minutes
    FROM meetings
    WHERE condo_id = condo_id_param
    ORDER BY meeting_date DESC
    LIMIT 1;

    -- Si no se encuentran minutas, devolver un mensaje indicativo
    IF latest_minutes IS NULL THEN
        SET latest_minutes = 'No meeting minutes available.';
    END IF;

    RETURN latest_minutes;
END //

DELIMITER ;

DELIMITER //

/**
 * Calculate the total penalties accumulated by a specific unit due to violations of condominium rules.
 * 
 * @param {INT} unit_id_param - The ID of the unit for which to calculate the total penalties.
 * @returns {DECIMAL(10, 2)} - The total amount of penalties. Returns 0 if there are no penalties.
 */

CREATE FUNCTION calculate_total_penalties_for_unit(
    unit_id_param INT
) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_penalties DECIMAL(10, 2);

    -- Calcular el total de penalizaciones acumuladas para la unidad especificada
    SELECT SUM(penalty) INTO total_penalties
    FROM violations
    WHERE unit_id = unit_id_param;

    -- Si no hay penalizaciones, devolver 0
    IF total_penalties IS NULL THEN
        SET total_penalties = 0;
    END IF;

    RETURN total_penalties;
END //

DELIMITER ;
