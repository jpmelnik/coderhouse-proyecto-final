-- Seleccionar la base de datos para usarla
USE consortium_db;

-- Crear el trigger `after_payment_insert`
-- Este trigger se ejecuta después de que se inserta un nuevo pago y actualiza el fondo de reserva del consorcio asociado.
DELIMITER //

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

-- Crear el trigger `before_owner_delete`
-- Este trigger previene la eliminación de un propietario si todavía tiene unidades asociadas activas en el sistema.
DELIMITER //

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

-- Crear el trigger `after_common_expense_update`
-- Este trigger registra cualquier cambio en la tabla `common_expenses` en una tabla de auditoría para mantener un historial de modificaciones.
DELIMITER //

CREATE TRIGGER after_common_expense_update
AFTER UPDATE ON common_expenses
FOR EACH ROW
BEGIN
    -- Insertar los cambios en la tabla de auditoría
    INSERT INTO common_expenses_audit (expense_id, condo_id, old_amount, new_amount)
    VALUES (OLD.expense_id, OLD.condo_id, OLD.amount, NEW.amount);
END //

DELIMITER ;

-- Crear el trigger `after_violation_insert`
-- Este trigger se ejecuta después de que se inserta una nueva violación y notifica al propietario.
DELIMITER //

CREATE TRIGGER after_violation_insert
AFTER INSERT ON violations
FOR EACH ROW
BEGIN
    -- Notificación o lógica adicional para manejar la violación
    -- (Este trigger puede usarse para enviar notificaciones o actualizar otras tablas)
    CALL notify_owner_of_violation(NEW.unit_id, NEW.description, NEW.date);
END //

DELIMITER ;