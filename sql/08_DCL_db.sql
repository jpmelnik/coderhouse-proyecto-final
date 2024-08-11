-- Seleccionar la base de datos para usarla
USE consortium_db;

-- #####################################################
-- Creación de Usuarios y Asignación de Permisos
-- #####################################################

/**
 * Creación de usuarios para la gestión del sistema consorcio_db.
 * 
 * Incluye:
 * - Creación de usuarios con diferentes niveles de acceso.
 * - Validación para evitar la creación de usuarios duplicados.
 * - Asignación de permisos específicos a cada usuario.
 * - Validación para evitar la asignación de permisos duplicados.
 */

/* Crear el usuario 'admin_user' si no existe */
IF NOT EXISTS (SELECT 1 FROM mysql.user WHERE user = 'admin_user' AND host = 'localhost') THEN
    CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'secure_password';
END IF;

/* Crear el usuario 'condo_manager' si no existe */
IF NOT EXISTS (SELECT 1 FROM mysql.user WHERE user = 'condo_manager' AND host = 'localhost') THEN
    CREATE USER 'condo_manager'@'localhost' IDENTIFIED BY 'secure_password';
END IF;

/* Crear el usuario 'owner_user' si no existe */
IF NOT EXISTS (SELECT 1 FROM mysql.user WHERE user = 'owner_user' AND host = 'localhost') THEN
    CREATE USER 'owner_user'@'localhost' IDENTIFIED BY 'secure_password';
END IF;

-- #####################################################
-- Asignación de Permisos
-- #####################################################

/**
 * Asignación de permisos a los usuarios.
 * 
 * Incluye:
 * - Validación para evitar la asignación duplicada de permisos.
 */

/* Asignar todos los privilegios al usuario 'admin_user' */
GRANT ALL PRIVILEGES ON consortium_db.* TO 'admin_user'@'localhost';

-- Verificar y asignar permisos al 'condo_manager'
IF NOT EXISTS (
    SELECT 1 FROM mysql.db 
    WHERE User = 'condo_manager' 
    AND Host = 'localhost' 
    AND Db = 'consortium_db' 
    AND Select_priv = 'Y'
) THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.condominiums TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.units TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.owners TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.expenses TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.payments TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.common_expenses TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.maintenance TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.violations TO 'condo_manager'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE ON consortium_db.complaints TO 'condo_manager'@'localhost';
END IF;

/* Asignar permisos de solo lectura al 'owner_user' */
IF NOT EXISTS (
    SELECT 1 FROM mysql.db 
    WHERE User = 'owner_user' 
    AND Host = 'localhost' 
    AND Db = 'consortium_db' 
    AND Select_priv = 'Y'
) THEN
    GRANT SELECT ON consortium_db.condominiums TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.units TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.owners TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.expenses TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.payments TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.common_expenses TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.maintenance TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.violations TO 'owner_user'@'localhost';
    GRANT SELECT ON consortium_db.complaints TO 'owner_user'@'localhost';
END IF;

-- #####################################################
-- Revocación de Permisos
-- #####################################################

/**
 * Revocación de permisos previamente otorgados.
 * 
 * Incluye:
 * - Revocación de todos los permisos asignados a un usuario.
 * - Validación para evitar la revocación si los permisos ya no existen.
 */

/* Revocar todos los permisos del 'condo_manager' */
IF EXISTS (
    SELECT 1 FROM mysql.db 
    WHERE User = 'condo_manager' 
    AND Host = 'localhost' 
    AND Db = 'consortium_db'
) THEN
    REVOKE ALL PRIVILEGES ON consortium_db.* FROM 'condo_manager'@'localhost';
END IF;

/* Revocar permisos de solo lectura de 'owner_user' */
IF EXISTS (
    SELECT 1 FROM mysql.db 
    WHERE User = 'owner_user' 
    AND Host = 'localhost' 
    AND Db = 'consortium_db' 
    AND Select_priv = 'Y'
) THEN
    REVOKE SELECT ON consortium_db.condominiums FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.units FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.owners FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.expenses FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.payments FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.common_expenses FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.maintenance FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.violations FROM 'owner_user'@'localhost';
    REVOKE SELECT ON consortium_db.complaints FROM 'owner_user'@'localhost';
END IF;

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;
