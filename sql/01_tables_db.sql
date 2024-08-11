-- Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS consortium_db;

-- Crear la base de datos
CREATE DATABASE consortium_db;

-- Seleccionar la base de datos para usarla
USE consortium_db;

-- #####################################################
-- Creación de Tablas con Validaciones y Documentación
-- #####################################################

/**
 * Tabla: administrators
 * 
 * Descripción:
 * Almacena información sobre los administradores responsables de la gestión de los consorcios.
 * 
 * Validaciones:
 * - Se asegura que el nombre y apellido sean obligatorios.
 * - Se permite un único identificador de administrador (admin_id).
 */
CREATE TABLE IF NOT EXISTS administrators (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del administrador
    first_name VARCHAR(255) NOT NULL,         -- Nombre del administrador
    last_name VARCHAR(255) NOT NULL,          -- Apellido del administrador
    phone VARCHAR(50),                        -- Número de teléfono del administrador
    email VARCHAR(255)                        -- Correo electrónico del administrador
);

-- #####################################################

/**
 * Tabla: condominiums
 * 
 * Descripción:
 * Contiene los detalles de cada condominio administrado, incluyendo nombre, dirección, y fondo de reserva.
 * 
 * Validaciones:
 * - Se asegura que el nombre, dirección y fecha de creación del condominio sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `administrators`.
 */
CREATE TABLE IF NOT EXISTS condominiums (
    condo_id INT PRIMARY KEY AUTO_INCREMENT,      -- Identificador único del condominio
    condo_name VARCHAR(255) NOT NULL,             -- Nombre del condominio
    address VARCHAR(255) NOT NULL,                -- Dirección del condominio
    unit_count INT NOT NULL,                      -- Número de unidades en el condominio
    creation_date DATE NOT NULL,                  -- Fecha de creación del condominio
    admin_id INT,                                 -- Referencia al administrador responsable (FK)
    contact_phone VARCHAR(50),                    -- Teléfono de contacto del condominio
    contact_email VARCHAR(255),                   -- Correo electrónico de contacto del condominio
    reserve_fund DECIMAL(10, 2),                  -- Fondo de reserva disponible del condominio
    status VARCHAR(50),                           -- Estado actual del condominio (e.g., Activo, Inactivo)
    last_meeting_date DATE,                       -- Fecha de la última reunión del consorcio
    FOREIGN KEY (admin_id) REFERENCES administrators(admin_id)  -- Clave foránea que relaciona con la tabla `administrators`
);

-- #####################################################

/**
 * Tabla: units
 * 
 * Descripción:
 * Almacena la información de las unidades dentro de los condominios.
 * 
 * Validaciones:
 * - Se asegura que el número de unidad, tipo, y referencia al condominio sean obligatorios.
 * - Incluye claves foráneas que referencian a las tablas `condominiums` y `owners`.
 */
CREATE TABLE IF NOT EXISTS units (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,      -- Identificador único de la unidad
    condo_id INT NOT NULL,                       -- Referencia al condominio al que pertenece la unidad (FK)
    number VARCHAR(50) NOT NULL,                 -- Número de la unidad
    type VARCHAR(50) NOT NULL,                   -- Tipo de unidad (e.g., Apartamento, Oficina)
    square_meters DECIMAL(10, 2),                -- Tamaño de la unidad en metros cuadrados
    owner_id INT,                                -- Referencia al propietario de la unidad (FK)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id),  -- Clave foránea que relaciona con la tabla `condominiums`
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id)         -- Clave foránea que relaciona con la tabla `owners`
);

-- #####################################################

/**
 * Tabla: owners
 * 
 * Descripción:
 * Guarda la información de los propietarios de las unidades dentro de los condominios.
 * 
 * Validaciones:
 * - Se asegura que el nombre y apellido del propietario sean obligatorios.
 */
CREATE TABLE IF NOT EXISTS owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del propietario
    first_name VARCHAR(255) NOT NULL,         -- Nombre del propietario
    last_name VARCHAR(255) NOT NULL,          -- Apellido del propietario
    phone VARCHAR(50),                        -- Número de teléfono del propietario
    email VARCHAR(255)                        -- Correo electrónico del propietario
);

-- #####################################################

/**
 * Tabla: expenses
 * 
 * Descripción:
 * Almacena las expensas asociadas a cada unidad, incluyendo el monto y el estado de pago.
 * 
 * Validaciones:
 * - Se asegura que la referencia a la unidad, el monto total y el estado de pago sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `units`.
 */
CREATE TABLE IF NOT EXISTS expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la expensa
    unit_id INT NOT NULL,                       -- Referencia a la unidad a la que corresponde la expensa (FK)
    month_year DATE NOT NULL,                   -- Mes y año de la expensa
    total_amount DECIMAL(10, 2) NOT NULL,       -- Monto total de la expensa
    payment_status VARCHAR(50) NOT NULL,        -- Estado del pago de la expensa (e.g., Pagado, Pendiente)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- #####################################################

/**
 * Tabla: payments
 * 
 * Descripción:
 * Registra los pagos realizados por los propietarios para cubrir las expensas de sus unidades.
 * 
 * Validaciones:
 * - Se asegura que la referencia a la expensa, la fecha de pago, el monto y el método de pago sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `expenses`.
 */
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del pago
    expense_id INT NOT NULL,                    -- Referencia a la expensa relacionada con el pago (FK)
    payment_date DATE NOT NULL,                 -- Fecha en la que se realizó el pago
    amount DECIMAL(10, 2) NOT NULL,             -- Monto pagado
    payment_method VARCHAR(50) NOT NULL,        -- Método de pago utilizado (e.g., Transferencia, Tarjeta)
    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id)  -- Clave foránea que relaciona con la tabla `expenses`
);

-- #####################################################

/**
 * Tabla: common_expenses
 * 
 * Descripción:
 * Contiene los gastos comunes que se aplican a todo el condominio, como mantenimiento, servicios y reparaciones.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, la descripción, la fecha, el monto y la categoría del gasto sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS common_expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del gasto común
    condo_id INT NOT NULL,                      -- Referencia al condominio al que corresponde el gasto común (FK)
    description VARCHAR(255) NOT NULL,          -- Descripción del gasto común
    date DATE NOT NULL,                         -- Fecha en la que se registró el gasto
    amount DECIMAL(10, 2) NOT NULL,             -- Monto del gasto común
    category VARCHAR(50) NOT NULL,              -- Categoría del gasto (e.g., Mantenimiento, Servicios, Reparaciones)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: common_expenses_audit
 * 
 * Descripción:
 * Esta tabla de auditoría registra los cambios realizados en los gastos comunes, permitiendo un seguimiento detallado de las modificaciones.
 * 
 * Validaciones:
 * - Se asegura que la referencia al gasto común, la referencia al condominio, el monto anterior y el nuevo monto sean obligatorios.
 * - Incluye claves foráneas que referencian a las tablas `common_expenses` y `condominiums`.
 */
CREATE TABLE IF NOT EXISTS common_expenses_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del registro de auditoría
    expense_id INT,                           -- Referencia al gasto común que fue modificado (FK)
    condo_id INT,                             -- Referencia al condominio asociado al gasto común (FK)
    old_amount DECIMAL(10, 2),                -- Monto anterior del gasto común antes de la modificación
    new_amount DECIMAL(10, 2),                -- Monto nuevo del gasto común después de la modificación
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Fecha y hora en que se realizó la modificación
    FOREIGN KEY (expense_id) REFERENCES common_expenses(expense_id),  -- Clave foránea que relaciona con la tabla `common_expenses`
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)           -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: maintenance
 * 
 * Descripción:
 * Almacena los detalles de los trabajos de mantenimiento programados para cada condominio.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, la descripción, la fecha programada, el proveedor y el costo estimado sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS maintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del trabajo de mantenimiento
    condo_id INT NOT NULL,                          -- Referencia al condominio al que pertenece el mantenimiento (FK)
    description VARCHAR(255) NOT NULL,              -- Descripción del trabajo de mantenimiento
    scheduled_date DATE NOT NULL,                   -- Fecha programada para el mantenimiento
    provider VARCHAR(255) NOT NULL,                 -- Proveedor del servicio de mantenimiento
    estimated_cost DECIMAL(10, 2) NOT NULL,         -- Costo estimado del mantenimiento
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: service_providers
 * 
 * Descripción:
 * Almacena la información de los proveedores de servicios de mantenimiento y otros servicios.
 * 
 * Validaciones:
 * - Se asegura que el nombre, teléfono, correo electrónico y tipo de servicio sean obligatorios.
 */
CREATE TABLE IF NOT EXISTS service_providers (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del proveedor de servicios
    name VARCHAR(255) NOT NULL,                  -- Nombre del proveedor de servicios
    phone VARCHAR(50) NOT NULL,                  -- Número de teléfono del proveedor
    email VARCHAR(255) NOT NULL,                 -- Correo electrónico del proveedor
    service_type VARCHAR(255) NOT NULL           -- Tipo de servicio proporcionado (e.g., Mantenimiento, Seguridad)
);

-- #####################################################

/**
 * Tabla: meetings
 * 
 * Descripción:
 * Almacena la información sobre las reuniones de consorcio programadas para cada condominio.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, la fecha de la reunión y la agenda sean obligatorias.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS meetings (
    meeting_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la reunión
    condo_id INT NOT NULL,                      -- Referencia al condominio asociado a la reunión (FK)
    meeting_date DATE NOT NULL,                 -- Fecha de la reunión
    agenda TEXT NOT NULL,                       -- Agenda de la reunión
    minutes TEXT,                               -- Minutas de la reunión
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: violations
 * 
 * Descripción:
 * Almacena las violaciones a las reglas del consorcio cometidas por los propietarios o inquilinos.
 * 
 * Validaciones:
 * - Se asegura que la referencia a la unidad, la descripción de la violación, la fecha y el estado sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `units`.
 */
CREATE TABLE IF NOT EXISTS violations (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la violación
    unit_id INT NOT NULL,                         -- Referencia a la unidad relacionada con la violación (FK)
    description VARCHAR(255) NOT NULL,            -- Descripción de la violación
    date DATE NOT NULL,                           -- Fecha de la violación
    penalty DECIMAL(10, 2),                       -- Penalización impuesta por la violación
    status VARCHAR(50) NOT NULL,                  -- Estado de la violación (e.g., Pendiente, Resuelto)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- #####################################################

/**
 * Tabla: complaints
 * 
 * Descripción:
 * Almacena las quejas presentadas por los propietarios o inquilinos en relación con el consorcio o la administración.
 * 
 * Validaciones:
 * - Se asegura que la referencia a la unidad, la descripción de la queja, la fecha de presentación y el estado sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `units`.
 */
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la queja
    unit_id INT NOT NULL,                         -- Referencia a la unidad desde donde se presentó la queja (FK)
    description TEXT NOT NULL,                    -- Descripción de la queja
    date_submitted DATE NOT NULL,                 -- Fecha en la que se presentó la queja
    status VARCHAR(50) NOT NULL,                  -- Estado de la queja (e.g., Pendiente, Resuelto)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- #####################################################

/**
 * Tabla: events
 * 
 * Descripción:
 * Almacena los eventos comunitarios organizados en los condominios.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, el nombre del evento, la fecha y el organizador sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del evento
    condo_id INT NOT NULL,                    -- Referencia al condominio donde se realizará el evento (FK)
    event_name VARCHAR(255) NOT NULL,         -- Nombre del evento
    event_date DATE NOT NULL,                 -- Fecha del evento
    description TEXT,                         -- Descripción del evento
    organizer VARCHAR(255) NOT NULL,          -- Organizador del evento
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: emergency_contacts
 * 
 * Descripción:
 * Almacena los contactos de emergencia para cada condominio.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, el nombre del contacto, el teléfono y la relación con el consorcio sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS emergency_contacts (
    contact_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del contacto de emergencia
    condo_id INT NOT NULL,                      -- Referencia al condominio al que pertenece el contacto (FK)
    contact_name VARCHAR(255) NOT NULL,         -- Nombre del contacto de emergencia
    phone VARCHAR(50) NOT NULL,                 -- Número de teléfono del contacto de emergencia
    email VARCHAR(255),                         -- Correo electrónico del contacto de emergencia
    relationship VARCHAR(50) NOT NULL,          -- Relación del contacto con el consorcio (e.g., Bomberos, Policía)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- #####################################################

/**
 * Tabla: insurance_policies
 * 
 * Descripción:
 * Almacena la información de las pólizas de seguro asociadas a los condominios.
 * 
 * Validaciones:
 * - Se asegura que la referencia al condominio, el nombre del proveedor, el número de la póliza, el monto de la cobertura y la fecha de vencimiento sean obligatorios.
 * - Incluye una clave foránea que referencia a la tabla `condominiums`.
 */
CREATE TABLE IF NOT EXISTS insurance_policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la póliza de seguro
    condo_id INT NOT NULL,                     -- Referencia al condominio cubierto por la póliza (FK)
    provider_name VARCHAR(255) NOT NULL,       -- Nombre del proveedor del seguro
    policy_number VARCHAR(255) NOT NULL,       -- Número de la póliza
    coverage_amount DECIMAL(10, 2) NOT NULL,   -- Monto de la cobertura
    expiration_date DATE NOT NULL,             -- Fecha de vencimiento de la póliza
    contact_phone VARCHAR(50) NOT NULL,        -- Teléfono de contacto del proveedor del seguro
    contact_email VARCHAR(255),                -- Correo electrónico del proveedor del seguro
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);
