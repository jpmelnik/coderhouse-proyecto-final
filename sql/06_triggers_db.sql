-- Seleccionar la base de datos para usarla
USE consortium_db;

DELIMITER //

/**
 * Trigger: after_payment_insert
 * 
 * Descripción:
 * Este trigger se ejecuta automáticamente después de que se inserta un nuevo pago en la tabla `payments`.
 * Su función principal es actualizar el fondo de reserva del consorcio asociado a la unidad que realizó el pago,
 * sumando el monto del pago al fondo de reserva.
 * 
 * Comportamiento:
 * - Obtiene el ID del consorcio asociado a la unidad que realizó el pago.
 * - Actualiza el fondo de reserva del consorcio, sumando el monto del pago.
 */
CREATE TRIGGER after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE condo_id INT;

    -- Obtener el ID del consorcio asociado a la unidad que realizó el pago
    SELECT u.condo_id INTO condo_id
    FROM units u
    JOIN expenses e ON u.unit_id = e.unit_id
    WHERE e.expense_id = NEW.expense_id;

    -- Actualizar el fondo de reserva del consorcio sumando el monto del pago
    UPDATE condominiums
    SET reserve_fund = reserve_fund + NEW.amount
    WHERE condo_id = condo_id;
END //

DELIMITER ;

DELIMITER //

/**
 * Trigger: before_owner_delete
 * 
 * Descripción:
 * Este trigger se ejecuta automáticamente antes de que se elimine un propietario de la tabla `owners`.
 * Su función es prevenir la eliminación de un propietario si todavía tiene unidades asociadas activas en el sistema.
 * 
 * Comportamiento:
 * - Cuenta el número de unidades asociadas al propietario que se intenta eliminar.
 * - Si el propietario tiene unidades asociadas, se previene su eliminación y se emite un mensaje de error.
 */
CREATE TRIGGER before_owner_delete
BEFORE DELETE ON owners
FOR EACH ROW
BEGIN
    DECLARE unit_count INT;

    -- Contar el número de unidades asociadas al propietario que se intenta eliminar
    SELECT COUNT(*)
    INTO unit_count
    FROM units
    WHERE owner_id = OLD.owner_id;

    -- Si hay unidades asociadas, prevenir la eliminación del propietario
    IF unit_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar al propietario porque todavía tiene unidades asociadas.';
    END IF;
END //

DELIMITER ;

DELIMITER //

/**
 * Trigger: after_common_expense_update
 * 
 * Descripción:
 * Este trigger se ejecuta automáticamente después de que se actualiza un registro en la tabla `common_expenses`.
 * Su propósito es registrar cualquier cambio en la tabla `common_expenses` en una tabla de auditoría para
 * mantener un historial de modificaciones.
 * 
 * Comportamiento:
 * - Inserta un registro en la tabla `common_expenses_audit` con la información del cambio,
 *   incluyendo el ID de la expensa, el ID del condominio, el monto anterior, y el nuevo monto.
 */
CREATE TRIGGER after_common_expense_update
AFTER UPDATE ON common_expenses
FOR EACH ROW
BEGIN
    -- Insertar los cambios en la tabla de auditoría
    INSERT INTO common_expenses_audit (expense_id, condo_id, old_amount, new_amount)
    VALUES (OLD.expense_id, OLD.condo_id, OLD.amount, NEW.amount);
END //

DELIMITER ;

DELIMITER //

/**
 * Trigger: after_violation_insert
 * 
 * Descripción:
 * Este trigger se ejecuta automáticamente después de que se inserta una nueva violación en la tabla `violations`.
 * Su propósito es manejar la lógica adicional necesaria tras el registro de una violación, como notificar al propietario.
 * 
 * Comportamiento:
 * - Llama a un procedimiento almacenado `notify_owner_of_violation` para enviar una notificación al propietario
 *   acerca de la nueva violación registrada.
 */
CREATE TRIGGER after_violation_insert
AFTER INSERT ON violations
FOR EACH ROW
BEGIN
    -- Notificación o lógica adicional para manejar la violación
    CALL notify_owner_of_violation(NEW.unit_id, NEW.description, NEW.date);
END //

DELIMITER ;
