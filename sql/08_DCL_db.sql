-- Seleccionar la base de datos para usarla
USE consortium_db;

-- Crear un usuario para el administrador general del sistema
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'secure_password';

-- Crear un usuario para el administrador de consorcios
CREATE USER 'condo_manager'@'localhost' IDENTIFIED BY 'secure_password';

-- Crear un usuario para los propietarios, con acceso limitado
CREATE USER 'owner_user'@'localhost' IDENTIFIED BY 'secure_password';

-- Permisos para el Administrador General
-- Otorgar todos los permisos al usuario 'admin_user' para gestionar la base de datos
GRANT ALL PRIVILEGES ON consorcio_db.* TO 'admin_user'@'localhost';

-- Permisos para el Administrador de Consorcios
-- Otorgar permisos para gestionar tablas de condominios, unidades, propietarios, y expensas
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.condominiums TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.units TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.owners TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.expenses TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.payments TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.common_expenses TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.maintenance TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.violations TO 'condo_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON consorcio_db.complaints TO 'condo_manager'@'localhost';

-- Permisos para los Propietarios
-- Otorgar permisos de solo lectura a los propietarios
GRANT SELECT ON consorcio_db.condominiums TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.units TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.owners TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.expenses TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.payments TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.common_expenses TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.maintenance TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.violations TO 'owner_user'@'localhost';
GRANT SELECT ON consorcio_db.complaints TO 'owner_user'@'localhost';

-- Revocar todos los permisos del administrador de consorcios
REVOKE ALL PRIVILEGES ON consorcio_db.* FROM 'condo_manager'@'localhost';

-- Revocar permisos de solo lectura de un propietario
REVOKE SELECT ON consorcio_db.condominiums FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.units FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.owners FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.expenses FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.payments FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.common_expenses FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.maintenance FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.violations FROM 'owner_user'@'localhost';
REVOKE SELECT ON consorcio_db.complaints FROM 'owner_user'@'localhost';

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;